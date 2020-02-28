arr1 = %w[ruby rails]

puts  File.foreach("search-related-to-#{arr1.join('-')}.txt").grep(/ruby/).any?