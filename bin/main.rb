require 'nokogiri'
require 'open-uri'
require 'byebug'
require 'webdrivers'
require 'watir'

require_relative '../lib/browser.rb'
require_relative '../lib/write_file.rb'

class Start
  attr_reader :page, :write
  
  def initialize
    $page = 1
  end

  def validate_input
    puts "Search Hackernoon coding articles related to keywords"
    puts "Enter keywords separated with spaces eg. kw1 kw2"
    input = gets.chomp
    while input.empty?
      puts "Try again invalid input"
      puts "Enter keywords separated with spaces eg. kw1 kw2"
      input = gets.chomp
    end
    @search_input_arr = input.split(" ")
  end

  def start_search
    validate_input
    start = Browser.new
    start.parsed
    start.check_titles_inpage
    last_page = start.check_total_pages
    write = Filewrite.new(@search_input_arr)

    while ($page <= last_page)
      start.parsed_wait
      start.scrap_page(@search_input_arr)
      start.change_page
      $page += 1
    end
    write.classify(start.titles_arr, start.ref_arr)
    write.close_file
  end
  

end

new_search = Start.new
new_search.start_search