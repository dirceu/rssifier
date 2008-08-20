#
# Script to generate a Malvados (http://www.malvados.com.br) feed.
#
# Author: Dirceu Pereira Tiegs <dirceutiegs@gmail.com>
#
# You can see the result on http://dirceu.info/malvados.xml.
#

require 'rssify'

RSSFier.new('malvados.xml',
        'www.malvados.com.br',
        'http://www.malvados.com.br/',
        'Malvados - Quadrinhos de Humor',
        'Unofficial Malvados feed by Dirceu Pereira Tiegs - http://dirceu.info',
        'Malvados #{next_item}',
        '/index#{next_item}.html')
