require 'net/http'
require 'uri'
require 'rss/maker'

class RSSifier

  def initialize(p)
    @p = p
    @rss_filename = File.expand_path('.') + '/' + p[:filename]

    @next_item = p[:initial_item]
    if !@next_item
      guess_next_item
    end
  end

  def next_item
    @next_item = @p[:procs][:next_item].call(@next_item)
  end

  def _render_templ(s)
    s.gsub('#{next_item}', next_item.to_s)
  end

  def link_templ
    _render_templ(@p[:templates][:link])
  end

  def title_templ
    _render_templ(@p[:templates][:title])
  end

  def guess_next_item
    # guess the next possible comic number
    rss_content = open(@rss_filename) do |f| f.read end
    @next_item = RSS::Parser.parse(rss_content, false).items[0].link.scan(/(\d+)/)[0][0].to_i.next

    # if it doesn't exists, exit
    if (Net::HTTP.get_response URI.parse(link_templ)).code == "404"
      Process.exit
    end
  end

  def create_feed
    @content = RSS::Maker.make('2.0') do |m|
      m.channel.title = @p[:title]
      m.channel.link = @p[:home]
      m.channel.description = @p[:description]
      m.items.do_sort = true

      2.downto 0 do |n|
        response = (Net::HTTP.get_response URI.parse(link_templ))
        if response.code != "404"
          i = m.items.new_item
          i.title = title_templ
          i.description = @p[:procs][:body].call(response.body)
          i.link = link_templ
          i.date = Time.parse(response['last-modified'])
        end
        @next_item = next_item.to_i-1
      end
    end
  end

  def write_feed
    File.open(@rss_filename, "w") do |f|
      f.write(@content)
    end
  end
end

def rssify &block
  params = yield
  feed = RSSifier.new(params)
  feed.create_feed
  feed.write_feed
end
