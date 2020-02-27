class Browser
  attr_reader :parsed_page, :last_page, :titles, :titles_arr, :ref_arr
  def initialize
    @browser = Watir::Browser.new
    @browser.goto 'https://hackernoon.com/tagged/ruby'
    @titles_arr = []
    @ref_arr = []
  end

  def parsed
    @browser.element(css: "div#stats").wait_until(&:present?)
    js_rendered_content = @browser.element(css: "div#stats")
    @parsed_page = Nokogiri::HTML(@browser.html)
  end

  def parsed_wait
    @browser.element(css: "div#stats").wait_until(&:present?)
    js_rendered_content = @browser.element(css: "div#stats")
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

  def scrap_page(s_arr)
    @titles = @parsed_page.css('div.stories-item')
    @titles.each do |title|
      list = {
      title: title.css('h2 a').text,
      ref: "https://hackernoon.com" + title.css('h2 a')[0].attributes["href"].text
      }
      #puts list[:title]
      #@@write.classify(list[:ref], list[:title], list[:ref])
      if s_arr.all? { |i| list[:title].downcase.split().include?(i) }
        @titles_arr.push(list[:title])
        @ref_arr.push(list[:ref])
      end
    end
  end

  def change_page
    @browser.link(:aria_label => 'Next').click if $page < @last_page
  end


end