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

def converteArquivo4bits(path)
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

def converteArquivo7bits(path)
	vetor=[]
	String.new
	input = File.open(path, "r") do |file|
		all=file.read;
		vetor = all.split(' ')
	end
	return vetor
end

def codificaHamming47(vet4bits)
	codificado = []
	str = []
	for i in 0..(vet4bits.length-1)
		binarios = []
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
	return codificado
end

def decodificaHamming47(vet7bits)
	vet4bits=[]
	vet7bits.each do |str7Bits|
		str4Bits = String.new
		binarios=[]
		for i in 1..7
			if str7Bits[i-1].to_i==1
				binarios << "%03b" % i
			end
		end
		bitErrado = xor3Vetor(binarios).to_i(2)
		if bitErrado==0
			str4Bits[0]=str7Bits[3-1]
			str4Bits[1]=str7Bits[5-1]
			str4Bits[2]=str7Bits[6-1]
			str4Bits[3]=str7Bits[7-1]
		else
			# corrige
		end
		vet4bits << str4Bits
	end
	return vet4bits
end

def arrayToFile (array,path)
	File.open(path, "w") { |file|
		array.each do |x|
			file.write (x+" ");
		end
	}	
end

def stringToFile (str,path)
	File.open(path, "w") { |file|
		file.write (str);
	}	
end

def arrayToString (array, c)
	str = String.new
	i=0
	j=i+c-1;
	while i<(array.length-1)
		str=str+(array[i..j].join.to_i(2).chr)
		i=j+1
		j=i+c-1
	end
	return str
end

def insereErro (vetor)
	if ARGV.length>5
		abort "Numero de parametros incorreto"
	end
	for i in 2..(ARGV.length-1)
		if vetor[(ARGV[i].to_i)/7][(ARGV[i].to_i)%7]==1
			vetor[(ARGV[i].to_i)/7][(ARGV[i].to_i)%7]="0"
		else
			vetor[(ARGV[i].to_i)/7][(ARGV[i].to_i)%7]="1"
		end
	end
end

#main{
	vet4bits = []
	vet7bits = []
	case ARGV[0]
		when "-c"	
			vet4bits = converteArquivo4bits("input.in")
			vet7bits = codificaHamming47(vet4bits)
			insereErro (vet7bits)
			arrayToFile(vet7bits,"output.ham")
		when "-d"
			vet7bits = converteArquivo7bits("output.ham")
			vet4bits = decodificaHamming47(vet7bits)
			outputString = arrayToString(vet4bits,2)
			stringToFile(outputString,"input.txt")
		else
			abort ("Parametro Incorreto (Use -c ou -d)")
	end
#}