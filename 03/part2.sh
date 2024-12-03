#!/usr/bin/env sh

sum=0
do=true

grep -o "mul([0-9]\+,[0-9]\+)\|do()\|don't()" input >instructions
while read -r instruction; do
  if [ $instruction = "do()" ]; then
    do=true
  elif [ $instruction = "don't()" ]; then
    do=false
  fi

  if [ $do = true ] && [ $instruction != "do()" ]; then
    mul=$(($(echo $instruction | sed 's/mul(\([0-9]\+\),\([0-9]\+\))/\1*\2/')))
    sum=$((sum + mul))
  fi
done <instructions

rm instructions

echo $sum
