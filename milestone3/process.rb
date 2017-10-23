open(ARGV[0]) do |file|
  file.readlines.each do |line|
    s = line.strip.split
    if s[1] == "seconds" then
      puts s[0]
    end
  end
end
