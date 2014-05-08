# -*- coding: utf-8 -*-

binchars=[]
input = File.open(ARGV[0], "r") do |file|
	file.each_char do |c|
		binchars << c.to_s(2)
	end
end

puts binchars.to_yaml