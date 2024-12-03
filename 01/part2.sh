#!/usr/bin/env sh
#set -x

sum=0
sort_left=$(cut -f1 -d' ' input | sort)
cut -f4 -d' ' input | sort >sort_right

for left in $sort_left; do
  repeat=$(grep -c "$left" sort_right)
  sum=$((sum + left * repeat))
done

rm sort_right

echo $sum
