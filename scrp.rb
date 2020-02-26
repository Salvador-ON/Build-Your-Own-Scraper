require 'nokogiri'
require 'open-uri'
require 'byebug'
require 'webdrivers'
require 'watir'

def scraper(search_related)
  browser = Watir::Browser.new
  browser.goto 'https://hackernoon.com/tagged/ruby'
  browser.element(css: "div#stats").wait_until(&:present?)
  js_rendered_content = browser.element(css: "div#stats")
  parsed_page = Nokogiri::HTML(browser.html)

  articles = []

  titles = parsed_page.css('div.stories-item')
  art_in_page = titles.count
  total_articles = parsed_page.css('div#stats').text.split(' ')[0].to_i
  page = 1
  last_page = (total_articles / art_in_page.to_f).round
  file = File.open("#{search_related}.txt", "w")
  while (page) <= last_page 
    puts page
    browser.element(css: "div#stats").wait_until(&:present?)
    js_rendered_content = browser.element(css: "div#stats")
    sleep(1)
    parsed_page = Nokogiri::HTML(browser.html)
    titles = parsed_page.css('div.stories-item')
    titles.each do |title|
    list = {
      title: title.css('h2 a').text,
      tag: title.css('a.tag').text,
      ref: "https://hackernoontitle.css" + title.css('h2 a')[0].attributes["href"].text
    }
   
    puts "aded title: #{list[:title]}"
    puts "aded tag: #{list[:tag]}"
    puts "aded link: #{list[:ref]}"
    puts ""

    if list[:tag] == search_related
      file.puts "#{list[:title]}"
      file.puts "#{list[:tag]}"
      file.puts "#{list[:ref]}\n\n"
    end
    end
    browser.link(:aria_label => 'Next').click if page < 8
    
    page += 1
  end
  file.close
end


scraper("ruby")
scraper("ruby-on-rails")
scraper("bots")