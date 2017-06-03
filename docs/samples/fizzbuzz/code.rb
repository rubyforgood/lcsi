1.upto(100) do |i|
  out = ""
  out << "fizz" if (i % 3 == 0)
  out << "buzz" if (i % 5 == 0)
  puts out.empty? ? i : out
end
