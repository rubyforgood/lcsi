  topval = gets.chomp.to_i
  fizz = gets.chomp.split " "
  buzz = gets.chomp.split " "
  1.upto(topval) do |i|
    out = ""
    out << fizz[1] if (i % fizz[0].to_i == 0)
    out << buzz[1] if (i % buzz[0].to_i == 0)
    puts out.empty? ? i : out
  end