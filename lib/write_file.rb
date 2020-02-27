# frozen_string_literal: true

# Writting txt file
class Filewrite
  def initialize(search_arr)
    @file = File.open("search-related-to-#{search_arr.join('-')}.txt", 'w')
  end

  def classify(list_title, list_ref)
    (0...list_title.length).each do |n|
      @file.puts list_title[n].to_s
      @file.puts "#{list_ref[n]}\n\n"
    end
  end

  def close_file
    @file.close
  end
end
