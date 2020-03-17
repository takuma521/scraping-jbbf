require 'nokogiri'
require 'open-uri'
require 'pry'

JBBF_TOKYO_URL = 'http://tbbf.net/'

document = Nokogiri::HTML.parse(open(JBBF_TOKYO_URL))
newsList = document.css('p').map do |p|
  if p.children[1]&.name == 'a'
    contents = p.text.split(/[[:blank:]]./)
    {
      date: Date.strptime(contents[0],'%Y年%m月%d日'),
      text: contents[1],
      url: p.children[1].attributes['href'].value
    }
  end
end
puts newsList.compact
