#!/usr/bin/env sh

cp input traced

guard_line=$(sed -n '/.*^.*/=' input)
guard_index=$(grep -o '.*^' input)
guard_index=${#guard_index}

go_north() {
  while true; do
    # obstacle in front of guard
    line=$(sed -n "$((guard_line - 1)) p" traced)
    echo $line | grep -qE "^.{$((guard_index - 1))}#" && go_east && break

    sed -i "$guard_line s/\^/X/" traced
    guard_line=$((guard_line - 1))
    sed -i "$guard_line s/./^/$guard_index" traced || break
  done
}

go_east() {
  while true; do
    line=$(sed -n "$guard_line p" traced)
    echo $line | grep -qE "^.{$((guard_index))}#" && go_south && break

    guard_index=$((guard_index + 1))
    sed -i "$guard_line s/./^/$guard_index" traced || {
      sed -i "$guard_line s/\^/X/" traced
      break
    }
    sed -i "$guard_line s/\^/X/" traced
  done
}

go_south() {
  while true; do
    line=$(sed -n "$((guard_line + 1)) p" traced)
    echo $line | grep -qE "^.{$((guard_index - 1))}#" && go_west && break

    sed -i "$guard_line s/\^/X/" traced
    guard_line=$((guard_line + 1))
    sed -i "$guard_line s/./^/$guard_index" traced || break
  done
}

go_west() {
  while true; do
    line=$(sed -n "$guard_line p" traced)
    echo $line | grep -qE "^.{$((guard_index - 2))}#" && go_north && break

    guard_index=$((guard_index - 1))
    sed -i "$guard_line s/./^/$guard_index" traced || {
      sed -i "$guard_line s/\^/X/2" traced
      break
    }
    sed -i "$guard_line s/\^/X/2" traced
  done
}

go_north

grep -o 'X' traced | wc -l
rm traced
