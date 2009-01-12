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
    :home => 'http://www.giantitp.com/comics/oots.html',
    :title => 'The Order of the Stick',
    :description => 'Unofficial OOtS feed by Dirceu Pereira Tiegs - http://dirceu.info',
    :templates => {
      :title => 'OOtS #{next_item}',
      :link => 'http://www.giantitp.com/comics/oots#{next_item}.html',
    },
    :procs => {
      :body => Proc.new {|s| "<p><img src='http://www.giantitp.com/" + s.scan(/(\/comics\/images\/.+.gif)/)[0][0] + "' /></p>" },
      :next_item => Proc.new { |next_item| "0#{next_item.to_i}" if next_item.to_i < 1000 },
    },
    :initial_item => ARGV[0],
  }
end
