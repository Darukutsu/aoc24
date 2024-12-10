#!/usr/bin/env sh
#set -x

files=$(sed -E 's/(.)./\1 /g' input)
holes=$(sed -E 's/.(.)/\1 /g' input)
reversed=$(echo "$files" | rev)

idn=$((${#files} / 2))
file_size=$(echo $reversed | grep -o '^.')
reversed=$(echo $reversed | sed 's/^.//')

id=0
input_len=$(cat input)
input_len=$((${#input_len} - 1))
#for i in $(seq 1 $(($(wc -m <input) - 1))); do
for i in $(seq 0 $input_len); do
  # HOLES
  if [ $((i % 2)) -eq 1 ]; then
    hole_size=$(echo $holes | grep -o '^.')
    holes=$(echo $holes | sed 's/^.//')

    for index in $(seq 1 $hole_size); do
      sum=$((sum + idn * counter))
      counter=$((counter + 1))

      file_size=$((file_size - 1))
      if [ $file_size -eq 0 ] && [ $index -ne $hole_size ]; then
        idn=$((idn - 1))
        file_size=$(echo $reversed | grep -o '^.')
        reversed=$(echo $reversed | sed 's/^.//')
      fi
    done

    if [ $file_size -eq 0 ]; then
      idn=$((idn - 1))
      file_size=$(echo $reversed | grep -o '^.')
      reversed=$(echo $reversed | sed 's/^.//')
    fi
  # FILES
  else
    block_size=$(echo $files | grep -o '^.')
    files=$(echo $files | sed 's/^.//')
    for _ in $(seq 1 $block_size); do
      sum=$((sum + id * counter))
      counter=$((counter + 1))
    done
    id=$((id + 1))
  fi
  [ $id -eq $((idn)) ] && break
done

if [ $file_size -ne 0 ]; then
  for _ in $(seq 1 $file_size); do
    sum=$((sum + idn * counter))
    counter=$((counter + 1))
  done
fi

echo $sum
