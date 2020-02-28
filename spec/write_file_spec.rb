# frozen_string_literal: true

require './lib/write_file.rb'

RSpec.describe Filewrite do

  arr1 = %w[RSPEC-TEST-ruby rails]
  arr2 = %w[RSPEC-TEST-www1 www2]
  

  describe '#Filewrite' do
    context 'when is initialize create a new file give true' do
      write = Filewrite.new(arr1)
      write.close_file
      it { expect(File.file?("searches/search-related-to-#{arr1.join('-')}.txt")).to eq(true) }
    end
  end

  describe '#classify' do
    write = Filewrite.new(arr1)
    write.classify(arr1, arr2)
    write.close_file
    context 'when classify in call write text file gibe true' do
      it { expect(File.foreach("searches/search-related-to-#{arr1.join('-')}.txt").grep(/ruby/).any?).to eq(true) }
    end
  end

  describe '#close_file' do
    write = Filewrite.new(arr1)
    write.classify(arr1, arr2)
    write.close_file
    context 'when classify in call write text file gibe true' do
      it { expect(write.file.closed?).to eq(true) }
    end
  end
end