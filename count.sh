#!/bin/bash 

echo "Hello World!"
my_files=$(ls -R ./media-record/**/*md & ls -Rr ./words/**/*md)

for filename in "${my_files[@]}"; do 
  # echo "We've got files: $filename"
  $(wc -l "$filename")
done 


