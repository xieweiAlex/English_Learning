#!/bin/bash 

echo "Hello World!"

# exclude_files=(
#   ""
# )

all_md_files=$(ls -R ./words/**/*md)

for filename in "${all_md_files[@]}"; do 
  echo "filename: $filename"
done 


