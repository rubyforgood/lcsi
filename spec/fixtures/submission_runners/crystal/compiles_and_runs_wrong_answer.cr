def piglatin(str : String)
  str.split("\n").each do |line|
    puts "#{line[1..-1].chomp}#{line[0...1]}ape"
  end
end

def piglatin(nil : Nil)
  puts
end

piglatin(gets)
piglatin(gets)
