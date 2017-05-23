ARGF.each do |line|
  puts "#{line[1..-1].chomp}#{line[0...1]}ay"
end
