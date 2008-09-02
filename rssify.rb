require 'net/http'
require 'rss/2.0'
require 'rss/maker'

class RSSFier
  
  attr_reader :next_item
  
  def initialize(filename,host,home,title,description,title_templ,link_templ,next_item)
    @host,@home,@title,@description,@title_templ,@link_templ,@next_item = host,home,title,description,title_templ,link_templ,next_item
    @rss_filename = File.expand_path('.') + '/' + filename
    if !@next_item
      guess_next_item
    end
    create_feed
    write_feed
  end
  
  def _render_templ(s)
    s.gsub('#{next_item}', next_item.to_s)
  end
  
  def link_templ
    _render_templ(@link_templ)
  end
  
  def title_templ
    _render_templ(@title_templ)
  end
  
  def guess_next_item
    # guess the next possible comic number
    rss_content = open(@rss_filename) do |f| f.read end
    @next_item = RSS::Parser.parse(rss_content, false).items[0].link.scan(/(\d+)/)[0][0].to_i.next

    # if it doesn't exists, exit
    if (Net::HTTP.get_response @host, link_templ).code == "404"
      Process.exit
    end
  end
  
  def create_feed
    @content = RSS::Maker.make('2.0') do |m|
      m.channel.title = @title
      m.channel.link = @home
      m.channel.description = @description
      m.items.do_sort = true

      2.downto 0 do |n|
        response = (Net::HTTP.get_response @host, link_templ)
        if response.code != "404"
          i = m.items.new_item
          i.title = title_templ
          i.description = get_body(response.body)
          i.link = "http://#{@host}#{link_templ}"
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
