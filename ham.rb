# -*- coding: utf-8 -*-

binchars=[]
input = File.open("input.txt", "r") do |file|
	file.each_char do |c|
		string = "%08b" % c.ord
		hi = string[0,4]
		lo = string[4,7]
		binchars << hi
		binchars << lo
	end
end

puts binchars