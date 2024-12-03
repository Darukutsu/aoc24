#!/usr/bin/env sh
#set -x

sum=0
sort_left=$(cut -f1 -d' ' input | sort)
#sort_right=$(cut -f4 -d' ' input | sort)
cut -f4 -d' ' input | sort >sort_right

for left in $sort_left; do
  right=$(head -n1 sort_right)
  sed -i '1d' sort_right
  ##sort_right="${sort_right#"$right"}"

  if [ $left -gt $right ]; then
    sum=$((sum + left - right))
    continue
  fi
  sum=$((sum + right - left))
done

rm sort_right

echo $sum
