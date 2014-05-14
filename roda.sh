#!/bin/bash
echo "Codificando com dicionario..."
time ruby ham.rb -c $@
# echo "Codificando sem dicionario..."
# time ruby ham_nohash.rb -c $@


x=$(echo $1 | cut -d "." -f1)
y=$x".ham"
z=$x".out"
echo "Decodificando..."
time ruby ham.rb -d $y

diff $1 $z