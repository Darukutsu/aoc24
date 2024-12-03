#!/usr/bin/env sh

day=$(basename "$PWD" | sed 's/^0//')
year=$(date +%Y)
aoc_session=""
curl --cookie "session=$aoc_session" https://adventofcode.com/$year/day/$day/input -o input
