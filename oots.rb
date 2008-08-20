#
# Script to generate an Order of the Stick (http://www.giantitp.com/comics/oots.html) feed.
#
# Author: Dirceu Pereira Tiegs <dirceutiegs@gmail.com>
#
# You can see the result on http://dirceu.info/oots.xml.
#

require 'net/http'
require 'rss/2.0'
require 'rss/maker'

rss_version = '2.0'
rss_filename = File.expand_path('.') + '/oots.xml'

def format_n(n)
  n = "0#{n}" if n < 1000
end

# get the next possible strip number
rss_content = open(rss_filename) do |f| f.read end
next_item = RSS::Parser.parse(rss_content, false).items[0].link.scan(/(\d+)/)[0][0].to_i.next
next_item = format_n(next_item)

# if it doesn't exists, exit
if (Net::HTTP.get_response 'www.giantitp.com', "/comics/oots#{next_item}.html").code == "404"
  Process.exit
end

# create a RSS feed
content = RSS::Maker.make(rss_version) do |m|
  m.channel.title = "The Order of the Stick"
  m.channel.link = "http://www.giantitp.com/comics/oots.html"
  m.channel.description = "Unofficial OOtS feed by Dirceu Pereira Tiegs - http://dirceu.info"
  m.items.do_sort = true

  2.downto 0 do |n|
    oots_link = "/comics/oots#{next_item}.html"
    response = (Net::HTTP.get_response 'www.giantitp.com', oots_link)
    if response.code != "404"
      i = m.items.new_item
      i.title = "OOtS #{next_item}"
      i.link = "http://www.giantitp.com/#{oots_link}"
      i.date = Time.parse(response['last-modified'])
    end
    next_item = format_n(next_item.to_i-1)
  end
end

# write it on the XML file
File.open(rss_filename, "w") do |f|
  f.write(content)
end