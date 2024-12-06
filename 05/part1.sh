#!/usr/bin/env sh

splitat=$(grep -n '^.\?$' input | grep -oE '[0-9]*')
head -n$((splitat - 1)) input | sort >rules
tail -n+$((splitat + 1)) input | sort >updates

OIFS=$IFS

while read -r line; do
  # adds 0.5s
  grep -E "$(echo $line | sed -e 's/,/$|/g' -e 's/$/$/')" rules |
    grep -E "$(echo $line | sed -e 's/,/|^/g' -e 's/^/^/')" >rules_for_line

  iscorrect=true
  IFS=,
  for number in $line; do
    if ! grep "$number$" rules_for_line | sed -E 's/(..)\|../\1/' | xargs -I{} sh -c "echo $line | grep -q {}.*$number"; then
      iscorrect=false
      break
    fi
    sed -i "/^$number/d" rules_for_line
  done
  IFS=$OIFS

  if [ $iscorrect = true ]; then
    mid=$(($(printf "%s" $line | wc -m) / 2))
    sum=$((sum + $(echo $line | sed -E "s/^.{$((mid - 1))}(..).*$/\1/")))
  fi

done <updates

echo $sum
rm rules updates rules_for_line
