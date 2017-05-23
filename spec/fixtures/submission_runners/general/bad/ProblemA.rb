ARGF.each do |line|
  puts "a#{line[1..-1].chomp}#{line[0...1]}ay"
end
