require 'nokogiri'
require 'open-uri'
require 'byebug'

def scraper
  url = "https://hackernoon.com"
  parsed_page = Nokogiri::HTML(open(url))

puts "-------------------------"
parsed_page.search('.title a').map do |x|
  puts x.inner_text
end

puts "-------------------------"
parsed_page.search('.title a').map do |x|
  puts x
end

puts "-------------------------"

parsed_page.search('.tag').map do |x|
  puts x.inner_text
end
  byebug
end

scraper