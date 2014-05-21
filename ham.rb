# -*- coding: utf-8 -*-

def xor3 (a,b)
# => xor de 3 bits
	c=[]
	for i in 0..2
		c << (a[i].to_i ^ b[i].to_i).to_s
	end
	c = c.join
	return c
end

def xor3Vetor (a)
# => xor de 3 bits entre os elementos de um vetor
	if !a.empty?
		x = a[0]
		for i in 1..(a.length-1)
			x=xor3(x,a[i])
		end
	else
		x="000"
	end
	return x
end

def converteArquivo4bits(path)
# => Abre um arquivo de texto e retorna um vetor em que cada elemento representa 4 bits dos dados desse arquivo
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
# => Abre arquivo codificado e retorna um vetor em que cada elemento representa um caractere em binario de 7 bits.
	vetor=[]
	String.new
	input = File.open(path, "r") do |file|
		all=file.read;
		vetor = all.split('')
	end
	for i in 0..(vetor.length-1)
		vetor[i]="%07b" % vetor[i].ord
	end
	return vetor
end

def codificaHamming74(vet4bits)
# => Aplica Hamming(7,4) transformando um vetor com elementos de 4 bits em um vetor com elementos de 7 bits.
	codificado = []
	str = []
	dicionario = Hash.new
	for i in 0..(vet4bits.length-1)
		if dicionario[vet4bits[i]].nil?	
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
			dicionario[vet4bits[i]]=str.join
		else
			codificado << dicionario[vet4bits[i]]*1
		end
	end
	return codificado
end

def decodificaHamming74(vet7bits)
# => Decodifica Hamming(7,4) transformando um vetor com elementos de 7 bits em um vetor com elementos de 4 bits.
	vet4bits=[]
	dicionario=Hash.new
	vet7bits.each do |str7Bits|
		if dicionario[str7Bits].nil?
			str4Bits = String.new
			binarios=[]
			for i in 1..7
				if str7Bits[i-1].to_i==1
					binarios << "%03b" % i
				end
			end
			bitErrado = xor3Vetor(binarios).to_i(2)
			if bitErrado!=0
				if (str7Bits[bitErrado-1])=="0"
					str7Bits[bitErrado-1]="1"
				else
					str7Bits[bitErrado-1]="0"
				end
			end
			str4Bits[0]=str7Bits[3-1]
			str4Bits[1]=str7Bits[5-1]
			str4Bits[2]=str7Bits[6-1]
			str4Bits[3]=str7Bits[7-1]
			vet4bits << str4Bits
			dicionario[str7Bits] = str4Bits
		else
			vet4bits << dicionario[str7Bits]*1
		end
	end
	return vet4bits
end

def arrayToFile (array,path)
# => Converte cada elemento binario do array em um char e o escreve em um arquivo.
	File.open(path, "w") { |file|
		array.each do |x|
			file.write (x.to_i(2).chr);
		end
	}	
end

def stringToFile (str,path)
# => Escreve a string str em um arquivo.
	File.open(path, "w") { |file|
		file.write (str);
	}	
end

def arrayToString (array)
# => Os elementos binarios do array sao concatenados 2 a 2, convertidos para char, que por sua vez formam uma string.
	str = String.new
	i=0;
	while i<(array.length-1)
		str<<(array[i..i+1].join.to_i(2).chr)
		i+=2;
	end
	return str
end

def insereErro (vetor)
# => Inverte o valor dos bits indicados por argumento no terminal.
	puts "Inserindo erros..."
	for i in 2..(ARGV.length-1)
		if (ARGV[i].to_i<(vetor.length*7)) && (ARGV[i].to_i>=0)
			if vetor[(ARGV[i].to_i)/7][(ARGV[i].to_i)%7]=="1"
				vetor[(ARGV[i].to_i)/7][(ARGV[i].to_i)%7]="0"
				puts "[bit "+ARGV[i]+"] - Valor do bit alterado para 0."
			else
				vetor[(ARGV[i].to_i)/7][(ARGV[i].to_i)%7]="1"
				puts "[bit "+ARGV[i]+"] - Valor do bit alterado para 1."
			end
		else
			puts "[bit "+ARGV[i]+"] - Nao existe nesse arquivo (erro nao inserido). [Ultimo bit: "+(vetor.length*7-1).to_s+"]"
		end
	end
end

#main{
	vet4bits = []
	vet7bits = []
	if ARGV.length>7
		abort "Numero de parametros incorreto"
	end
	case ARGV[0]
		when "-c"	
			vet4bits = converteArquivo4bits(ARGV[1])
			vet7bits = codificaHamming74(vet4bits)
			if ARGV.length>2
				insereErro (vet7bits)
			end
			arrayToFile(vet7bits,(ARGV[1].split('.').first)+".ham")
		when "-d"
			vet7bits = converteArquivo7bits(ARGV[1])
			vet4bits = decodificaHamming74(vet7bits)
			outputString = arrayToString(vet4bits)
			stringToFile(outputString,(ARGV[1].split('.').first)+".out")
		else
			abort ("Parametro Incorreto (Use -c ou -d)")
	end
#}