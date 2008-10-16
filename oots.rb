#
# Script to generate an Order of the Stick (http://www.giantitp.com/comics/oots.html) feed.
#
# Author: Dirceu Pereira Tiegs <dirceutiegs@gmail.com>
#
# You can see the result on http://dirceu.info/oots.xml.
#

require 'rssify'

rssify do
  { 
    :filename => 'oots.xml',
    :host => 'www.giantitp.com',
    :home => 'http://www.giantitp.com/comics/oots.html',
    :title => 'The Order of the Stick',
    :description => 'Unofficial OOtS feed by Dirceu Pereira Tiegs - http://dirceu.info',
    :title_templ =>  'OOtS #{next_item}',
    :link_templ => '/comics/oots#{next_item}.html',
    :get_body => Proc.new {|s| "<p><img src='http://www.giantitp.com/" + s.scan(/(\/comics\/images\/.+.gif)/)[0][0] + "' /></p>" },
    :next_item_getter => Proc.new { |next_item| "0#{next_item.to_i}" if next_item.to_i < 1000 },
    :next_item => ARGV[0],
  }
end
