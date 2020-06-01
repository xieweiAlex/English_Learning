#!/bin/bash

file=words-new.md

while read -r line; do
  # echo "line: $line"

  # sed -i '' "s//  /" "$file_name"
  if [[ "$line" =~ [\t\r\n]+$ ]]; then 
    echo "line: $line"
  fi

done <$file

echo "We're done!"

