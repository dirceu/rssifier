#
# Script to generate a Malvados (http://www.malvados.com.br) feed.
#
# Author: Dirceu Pereira Tiegs <dirceutiegs@gmail.com>
#
# You can see the result on http://dirceu.info/malvados.xml.
#

require 'net/http'
require 'rss/2.0'
require 'rss/maker'

rss_version = '2.0'
rss_filename = File.expand_path('.') + '/malvados.xml'

# get the next possible strip number
rss_content = open(rss_filename) do |f| f.read end
next_item = RSS::Parser.parse(rss_content, false).items[0].link.scan(/(\d+)/)[0][0].to_i.next

# if it doesn't exists, exit
if (Net::HTTP.get_response 'www.malvados.com.br', "/index#{next_item}.html").code == "404"
  Process.exit
end

# create a RSS feed
content = RSS::Maker.make(rss_version) do |m|
  m.channel.title = "Malvados - Quadrinhos de Humor"
  m.channel.link = "http://www.malvados.com.br/"
  m.channel.description = "Unofficial Malvados feed by Dirceu Pereira Tiegs - http://dirceu.info"
  m.items.do_sort = true

  2.downto 0 do |n|
    oots_link = "/index#{next_item}.html"
    response = (Net::HTTP.get_response 'www.malvados.com.br', oots_link)
    if response.code != "404"
      i = m.items.new_item
      i.title = "Malvados #{next_item}"
      i.link = "http://www.malvados.com.br#{oots_link}"
      i.date = Time.parse(response['last-modified'])
    end
    next_item = next_item.to_i-1
  end
end

# write it on the XML file
File.open(rss_filename, "w") do |f|
  f.write(content)
end