# frozen_string_literal: true

# Browser Class, search for the target elements and save it in an array
class Browser
  attr_reader :parsed_page, :last_page, :titles, :titles_arr
  attr_reader :ref_arr, :art_in_page
  def initialize
    @browser = Watir::Browser.new
    @browser.goto 'https://hackernoon.com/tagged/ruby'
    @titles_arr = []
    @ref_arr = []
  end

  def parsed
    @browser.element(css: 'div#stats').wait_until(&:present?)
    @parsed_page = Nokogiri::HTML(@browser.html)
  end

  def parsed_wait
    @browser.element(css: 'div#stats').wait_until(&:present?)
    sleep(1)
    @parsed_page = Nokogiri::HTML(@browser.html)
  end

  def check_titles_inpage
    @titles = @parsed_page.css('div.stories-item')
    @art_in_page = titles.count
  end

  def check_total_pages
    total_articles = @parsed_page.css('div#stats').text.split(' ')[0].to_i
    @last_page = (total_articles / @art_in_page.to_f).round
    @last_page
  end

  # rubocop: disable Metrics/AbcSize
  def scrap_page(s_arr)
    @parsed_page.css('div.stories-item').each do |title|
      list_title = title.css('h2 a').text
      url = 'https://hackernoon.com'
      list_ref = url + title.css('h2 a')[0].attributes['href'].text
      list = { title: list_title, ref: list_ref }
      if s_arr.all? { |i| list[:title].downcase.split.include?(i) }
        @titles_arr.push(list[:title])
        @ref_arr.push(list[:ref])
      end
    end
  end
  # rubocop: enable Metrics/AbcSize

  def change_page(page)
    @browser.link(aria_label: 'Next').click if page < @last_page
  end
end
