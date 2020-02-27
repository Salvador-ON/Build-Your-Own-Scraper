require 'nokogiri'
require 'open-uri'
require 'byebug'
require 'webdrivers'
require 'watir'

def scraper(search_arr)
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
  file = File.open("search-related-to-#{search_arr.join('-')}.txt", "w")
  
  while (page) <= last_page 
    browser.element(css: "div#stats").wait_until(&:present?)
    js_rendered_content = browser.element(css: "div#stats")
    sleep(1)
    parsed_page = Nokogiri::HTML(browser.html)
    titles = parsed_page.css('div.stories-item')
    titles.each do |title|
    list = {
      title: title.css('h2 a').text,
      #tag: title.css('a.tag').text,
      ref: "https://hackernoontitle.css" + title.css('h2 a')[0].attributes["href"].text
    }
    if search_arr.all? { |i| list[:title].downcase.split().include?(i) }
      file.puts "#{list[:title]}"
      #file.puts "#{list[:tag]}"
      file.puts "#{list[:ref]}\n\n"
    end
    end
    browser.link(:aria_label => 'Next').click if page < 8
    
    page += 1
  end
  file.close
end

puts "Search Hackernoon coding articles related to keywords"
puts "Enter keywords separated with spaces eg. kw1 kw2"
input = gets.chomp

while input.empty?
  puts "Try again invalid input"
  puts "Enter keywords separated with spaces eg. kw1 kw2"
  input = gets.chomp
end

search_input_arr = input.split(" ")


scraper(search_input_arr)
