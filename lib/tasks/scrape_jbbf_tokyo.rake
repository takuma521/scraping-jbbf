namespace :scrape_jbbf_tokyo do
  JBBF_TOKYO_URL = 'http://tbbf.net/'
  desc "JBBF東京の最新情報を呟く"
  task :scrape => :environment do
    require 'nokogiri'
    require 'open-uri'
    require 'pry'
    document = Nokogiri::HTML.parse(open(JBBF_TOKYO_URL))
    document.css('p').each do |p|
      if p.children[1]&.name == 'a'
        unless Press.where(url: p.children[1].attributes['href'].value).exists?
          begin
            ActiveRecord::Base.transaction do
              # Twitter、LINEで最新情報が入ったと呟きDBに保存する
              puts '最新の情報がありました。'
              contents = p.text.split(/[[:blank:]]./)
              press = Press.new(
                body: contents[1],
                url: p.children[1].attributes['href'].value,
                date: Date.strptime(contents[0],'%Y年%m月%d日'),
                )
              press.save!

              client = Twitter::REST::Client.new do |config|
                config.consumer_key = Rails.application.credentials.twitter[:api_key]
                config.consumer_secret = Rails.application.credentials.twitter[:api_secret]
                config.access_token = Rails.application.credentials.twitter[:access_token]
                config.access_token_secret = Rails.application.credentials.twitter[:access_token_secret]
              end
              client.update("#{press.date} #{press.body}\n #{press.url}")
            end
          rescue => e
            puts "エラーが発生しました\n#{e}"
          end
        end
      end
    end
  end
end
