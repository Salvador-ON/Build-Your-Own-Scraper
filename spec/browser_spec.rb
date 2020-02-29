# frozen_string_literal: true

require './lib/browser.rb'
require 'nokogiri'
require 'open-uri'
require 'webdrivers'
require 'watir'

# rubocop: disable Metrics/BlockLength

RSpec.describe Browser do
  describe '#Browser' do
    context 'when is initialize give true if the 2 arrays init' do
      test = Browser.new
      test.close_window
      it { expect(test.titles_arr.empty? && test.ref_arr.empty?).to eq(true) }
    end
  end

  describe '#check_titles_inpage' do
    context 'when is call give true if parse is correct & title count match' do
      test = Browser.new
      test.parsed
      test.check_titles_inpage
      test.close_window
      it { expect(test.art_in_page).to eq(18) }
    end
  end

  describe '#check_total_pages' do
    context 'when is call give true ' do
      test = Browser.new
      test.parsed
      test.check_titles_inpage
      test.check_total_pages
      test.close_window
      it { expect((true if test.last_page > 0)).to eq(true) }
    end
  end

  describe '#scrap_page' do
    context 'when is call give true ' do
      test = Browser.new
      test.parsed
      test.scrap_page(%w[ruby])
      test.close_window
      it { expect((test.titles_arr.any? && test.ref_arr.any?)).to eq(true) }
    end
  end

  describe '#scrap_page' do
    context 'when is call give true ' do
      test = Browser.new
      test.parsed
      test.check_titles_inpage
      test.check_total_pages
      test.scrap_page(%w[ruby])
      count1 = test.titles_arr.count
      test.change_page(1)
      test.scrap_page(%w[ruby])
      count2 = test.titles_arr.count
      test.close_window
      it { expect((true if count2 > count1)).to eq(true) }
    end
  end
end

# rubocop: enable Metrics/BlockLength
