#!/bin/bash
echo "Codificando..."
time ruby ham_bin.rb -c $@

x=$(echo $1 | cut -d "." -f1)
y=$x".ham"
z=$x".out"
echo "Decodificando..."
time ruby ham_bin.rb -d $y

diff $1 $z