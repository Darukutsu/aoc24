#!/usr/bin/env sh

read_horizontal() {
  echo $(($(grep -o "XMAS" input | wc -l) + $(grep -o "SAMX" input | wc -l)))
}

# Problems that occur with this implementations is that regex does not match all subsequent matches that would be slightly shifted from previous one lets say XXMMAASS < there are 2 XMAS within this regex would look something like this:
#
# $ grep -o "X.M.A.S" # does not match both
#
# $ grep -oP "X(?=.M.A.S)" # matches both
#
# lookaround does not consume match so is able to match n times

read_vertical() {
  # chars in line
  ch=$(($(head -n1 input | wc -m) - 2))

  echo $(($(grep -oP "X(?=.{$ch}M.{$ch}A.{$ch}S)" "$1" | wc -l) + \
  $(grep -oP "S(?=.{$ch}A.{$ch}M.{$ch}X)" "$1" | wc -l)))
}

read_diagonal() {
  ch=$(($(head -n1 input | wc -m) - 1))

  # RIGHT DIAGONAL
  sum=$(($(grep -oP "X(?=.{$ch}M.{$ch}A.{$ch}S)" "$1" | wc -l) + \
  $(grep -oP "S(?=.{$ch}A.{$ch}M.{$ch}X)" "$1" | wc -l)))

  # LEFT DIAGONAL
  ch=$((ch - 2))
  sum=$((sum + $(grep -oP "X(?=.{$ch}M.{$ch}A.{$ch}S)" "$1" | wc -l) + \
  $(grep -oP "S(?=.{$ch}A.{$ch}M.{$ch}X)" "$1" | wc -l)))

  echo $sum
}

tr -d '\n' <input >newinput
echo $(($(read_horizontal) + $(read_vertical newinput) + $(read_diagonal newinput)))

rm newinput
