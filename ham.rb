# -*- coding: utf-8 -*-
def xor3 (a,b)
	c=[]
	for i in 0..2
		c << (a[i].to_i ^ b[i].to_i).to_s
	end
	c = c.join
	return c
end

def xor3Vetor (a)
	x = a[0]
	for i in 1..(a.length-1)
		x=xor3(x,a[i])
	end
	return x
end

def converteArquivo(path)
	binchars=[]
	input = File.open(path, "r") do |file|
		file.each_char do |c|
			string = "%08b" % c.ord
			hi = string[0,4]
			lo = string[4,7]
			binchars << hi
			binchars << lo
		end
	end
	return binchars
end

def hamming47(vet4bits)
	codificado = []
	str = []
	binarios = []
	for i in 0..(vet4bits.length-1)
		str[3]=vet4bits[i][0]
		if str[3]=="1"
			binarios << "%03b" % 3
		end
		str[5]=vet4bits[i][1]
		if str[5]=="1"
			binarios << "%03b" % 5
		end
		str[6]=vet4bits[i][2]
		if str[6]=="1"
			binarios << "%03b" % 6
		end
		str[7]=vet4bits[i][3]
		if str[7]=="1"
			binarios << "%03b" % 7
		end
		paridade = xor3Vetor(binarios)
		str[1] = paridade[2]
		str[2] = paridade[1]
		str[4] = paridade[0]

		codificado << str.join
	end
end

vet4bits = []
vet7bits = []
vet4bits = converteArquivo("input.txt")
vet7bits = hamming47(vet4bits)