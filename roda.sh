#!/bin/bash
echo "Codificando..."
time ruby ham.rb -c $@

x=$(echo $1 | cut -d "." -f1)
y=$x".ham"
z=$x".out"
echo "Decodificando..."
time ruby ham.rb -d $y

diff $1 $z