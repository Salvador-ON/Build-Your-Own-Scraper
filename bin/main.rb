# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'byebug'
require 'webdrivers'
require 'watir'

require_relative '../lib/browser.rb'
require_relative '../lib/write_file.rb'
# Start class that initizalize everything
class Start
  attr_reader :page, :write
  def initialize
    @page = 1
  end

  private

  def validate_input
    puts 'Search Hackernoon coding articles related to keywords'
    puts 'Enter keywords separated with spaces eg. kw1 kw2'
    input = gets.chomp
    while input.empty?
      puts 'Try again invalid input'
      puts 'Enter keywords separated with spaces eg. kw1 kw2'
      input = gets.chomp
    end
    @search_input_arr = input.split(' ')
  end

  public

  def start_search
    validate_input
    @start = Browser.new
    @start.parsed
    @start.check_titles_inpage
    @last_page = @start.check_total_pages
  end

  # rubocop: disable Metrics/MethodLength
  def writing_search
    write = Filewrite.new(@search_input_arr)
    write.build_html
    while @page <= @last_page
      @start.parsed_wait
      @start.scrap_page(@search_input_arr)
      @start.change_page(@page)
      @page += 1
    end
    write.classify(@start.titles_arr, @start.ref_arr)
    write.end_html
    write.close_file
    @start.close_window
    show_results
  end
  # rubocop: enable Metrics/MethodLength

  private

  def show_results
    puts ''
    puts 'I finished the search'
    puts "Related to the key words #{@search_input_arr.join(' ')}\n\n"
    puts "I found #{@start.titles_arr.count} articles related\n\n"
    puts "These are the articles that I found:\n\n"
    puts @start.titles_arr
    puts ''
    puts 'To visualize the articles go to the searches folder'
    puts "And open search-related-to-#{@search_input_arr.join('-')}.html"
    new_search
  end

  def new_search
    puts 'if you want to start a new search type Y'
    puts 'if you want to close the program type any other character'
    user_ans = gets.chomp.upcase
    search_again if user_ans == 'Y'
  end

  def search_again
    new_search = Start.new
    new_search.start_search
    new_search.writing_search
  end
end

new_search = Start.new
new_search.start_search
new_search.writing_search
