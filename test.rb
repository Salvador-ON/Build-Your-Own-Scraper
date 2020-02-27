class Txt
  def open
    @file = File.open("test.txt", "w")
  end

  def write
    @file.puts "hola"
  end

  def close
    @file.close
  end
end

hh = Txt.new

hh.open
hh.write
hh.close