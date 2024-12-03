#!/usr/bin/env sh
#set -x

safe=0

abs() {
  sum=$(($1 - $2))
  echo $((sum < 0 ? -sum : sum))
}

parse_line() {
  line="$1"

  n1=$(cut -f1 -d' ' line)
  n2=$(cut -f2 -d' ' line)

  if [ $n1 -lt $n2 ]; then
    sign=-lt
  else
    sign=-gt
  fi

  for _ in $line; do
    n1=$(cut -f1 -d' ' line)
    n2=$(cut -f2 -d' ' line)
    sed -i "s/$n1 \?//" line
    [ -z "$(cat line)" ] && break

    sum=$(abs $n1 $n2)
    isorder="$n1 $sign $n2"
    { test $isorder && test $sum -lt 4; } || return
  done
}

while read -r line; do
  echo $line >line
  if parse_line "$line"; then
    #echo "$line"
    safe=$((safe + 1))
  fi
done <input

rm line

echo $safe
