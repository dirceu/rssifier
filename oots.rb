#
# Script to generate an Order of the Stick (http://www.giantitp.com/comics/oots.html) feed.
#
# Author: Dirceu Pereira Tiegs <dirceutiegs@gmail.com>
#
# You can see the result on http://dirceu.info/oots.xml.
#

require 'rssify'

class OOtSRSSFier < RSSFier
  def next_item
    @next_tem = "0#{@next_item}" if @next_item < 1000
  end
end

OOtSRSSFier.new('oots.xml',
        'www.giantitp.com',
        'http://www.giantitp.com/comics/oots.html',
        'The Order of the Stick',
        'Unofficial OOtS feed by Dirceu Pereira Tiegs - http://dirceu.info',
        'OOtS #{next_item}',
        '/comics/oots#{next_item}.html')
