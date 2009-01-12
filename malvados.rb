#
# Script to generate a Malvados (http://www.malvados.com.br) feed.
#
# Author: Dirceu Pereira Tiegs <dirceutiegs@gmail.com>
#
# You can see the result on http://dirceu.info/malvados.xml.
#

require 'rssify'

rssify do
  {
    :filename => 'malvados.xml',
    :home => 'http://www.malvados.com.br/',
    :title => 'Malvados - Quadrinhos de Humor',
    :description => 'Unofficial Malvados feed by Dirceu Pereira Tiegs - http://dirceu.info',
    :templates => {
      :title =>  'Malvados #{next_item}',
      :link => 'http://www.malvados.com.br/index#{next_item}.html',
    },
    :procs => {
      :body => Proc.new {|s| "<p><img src='http://www.malvados.com.br/" + s.scan(/(tirinha\d+.gif)/)[0][0] + "' /></p>" },
      :next_item => Proc.new { |next_item| next_item },
    },
    :initial_item => ARGV[0],
  }
end
