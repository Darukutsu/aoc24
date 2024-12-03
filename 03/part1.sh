#!/usr/bin/env sh

sum=0

grep -o 'mul([0-9]\+,[0-9]\+)' input >instructions
while read -r instruction; do
  mul=$(($(echo $instruction | sed 's/mul(\([0-9]\+\),\([0-9]\+\))/\1*\2/')))
  sum=$((sum + mul))
done <instructions

rm instructions

echo $sum
