# frozen_string_literal: true

require './lib/write_file.rb'

# rubocop: disable Metrics/BlockLength

RSpec.describe Filewrite do
  arr1 = %w[RSPEC-TEST-ruby rails]
  p_name = 'searches/search-related-to-' + "#{arr1.join('-')}.html"

  describe '#Filewrite' do
    context 'when is initialize create a new file give true' do
      write = Filewrite.new(arr1)
      write.close_file
      it { expect(File.file?(p_name)).to eq(true) }
    end
  end

  describe '#build_html' do
    write = Filewrite.new(arr1)
    write.build_html
    write.close_file
    context 'when build is call write text & file give true' do
      it { expect(File.foreach(p_name).grep(/html/).any?).to eq(true) }
    end
  end

  describe '#classify' do
    write = Filewrite.new(arr1)
    write.classify(arr1, arr1)
    write.close_file
    context 'when classify is call write text & file give true' do
      it { expect(File.foreach(p_name).grep(/ruby/).any?).to eq(true) }
    end
  end

  describe '#end_html' do
    write = Filewrite.new(arr1)
    write.end_html
    write.close_file
    context 'when end is call write text & file give true' do
      it { expect(File.foreach(p_name).grep(/body/).any?).to eq(true) }
    end
  end

  describe '#close_file' do
    write = Filewrite.new(arr1)
    write.build_html
    write.classify(arr1, arr1)
    write.close_file
    context 'when classify in call write text file gibe true' do
      it { expect(write.file.closed?).to eq(true) }
    end
  end
end

# rubocop: enable Metrics/BlockLength
