#!/bin/bash 

source "./variable.sh"

# 2+ * & 1+ letter & .* & ends either 0 to 5 white space or line change  
PATTERN="\*{2,}[a-zA-Z]+.*-{1,3}(\s{0,5} | \n )$"

function countWords {
  total_count=0
  for file_path in "${files[@]}"; do 
    echo "File path: $file_path"

    count=$(Python3 count.py $file_path)
    echo -e "Current count: ${GREEN} $count ${NC}"
    total_count=$(( total_count + count ))
    echo -e "total count: ${YELLOW} $total_count ${NC}"
  done 

  # Persist the total_count 
  date=$(date +%Y/%m/%d)
  echo "$date: $total_count" >> "./record.md"
  # show the latest 5 records 
  tail -n 5 record.md
}

function getNewWords {
  for file_path in "${files[@]}"
  do 
    echo -e "Checking file: ${YELLOW} $file_path ${NC}"
    file_name=$(basename "$file_path")
    # file_content=$(ag "$PATTERN" -G "$file_path" --group --nonumbers --nofilename | sed '/^[[:space:]]*$/d') 
    file_content=$(ag "$PATTERN" -G "$file_path" --group --nonumbers | sed '/^[[:space:]]*$/d') 

    if [ -n "$file_content" ]; then 
      if [ -s "$WORDS_REVIEW" ]; then 
        echo "" >> "$WORDS_REVIEW"
      fi

      echo "## ${file_name} ## " >> "$WORDS_REVIEW"
      echo "$file_content" >> "$WORDS_REVIEW"
    fi
  done 

  lines=$(cat $WORDS_REVIEW | wc -l)
  # echo -e "File lines: ${YELLOW} $lines ${NC}, cut off lines beyond 110!"

  # Delete lines (111,$) let's keep the review file short & lean  
  # sed -i '' '111, 500d' "$WORDS_REVIEW"
}

# 1. PushBack changes in original file  
# 2. Purge the word_review file
function pushBack {
  file_name=""
  lineNum=0
  lines=""
  while read -r line; do
    lineNum=$(( lineNum + 1 ))
    if [[ $line == *md ]] && [[ -f $line ]]; then 
      file_name=$line
      echo -e " Trying to push back for file: ${YELLOW} $file_name ${NC}"
    fi

    if ! [[ -f $file_name ]]; then 
      echo "No file_name line yet, next line please."
      continue
    fi

    # trim ending white spaces  
    trimmedStr=$(echo "$line" | sed 's/ *$//g')

    # if trimmed_str contains "**{char}**" && not end in -  
    if [[ $trimmedStr =~ \*\*.+\*\*  ]] && ! [[ $trimmedStr =~ -$ ]]; then 

      echo -e "Update line: ${GREEN} $trimmedStr ${NC}, line: $lineNum" 
      
      # lines="$lines" + "$lineNum" + "d"
      lines+="$lineNum""d;"

      # escape from "*" to "\*" to help sed search/replace  
      # escapedStr=$(echo "$trimmedStr" | sed 's/\*/\\*/g')
      # find from the $file_name and replace the original str with updated string(two white space in the end) from words-review 
      # echo "Escaped line is ${escapedStr}"

      echo "Look up the lineNum in origin file ${file_name} " 
      originLinNum=$(grep -nF "${trimmedStr}" "${file_name}" | cut -d ":" -f 1 )
      echo "Origin line number: ${originLinNum}"

      echo "Removing the ending \"-\" in origin file."
      # sed -i '' "129s/-[[:blank:]]*$//g" words/2022/words-July.md
      sed -i '' "${originLinNum}s/-[[:blank:]]*$/  /g" "$file_name"
    fi

  done <$WORDS_REVIEW

  echo "Changed lines have been detected: $lines"
  cleanWordReview $lines
}

function cleanWordReview {

  echo -e "${GREEN} Purge the file $WORDS_REVIEW ${NC}"
  lines=$1

  # lines="14d;15d;16d;"
  sed -i '' "$lines" $WORDS_REVIEW

  # for line in $(echo "$lines" | tr " " "\n")
  # do
  #   echo "Line: $line"
  #   sed -i '' "$line"'d' $WORDS_REVIEW 
  # done
}

function ensure_trailing_spaces() {
  local file_path=$1

  echo "ensure_trailing_spaces... $file_path"

  # local file_path="./words/2023/words-Jan.md"

  # Read each line in the file
  while read -r line; do
    # If the line is not empty and doesn't end with more than 2 spaces
    if [ ! -z "$line" ] && [ "${line: -3}" != "   " ]; then
      line="$line  "
    fi
    # Append the line to the temporary file
    echo "$line" >> "${file_path}.tmp"
  done < "$file_path"

  # Replace the original file with the temporary file
  mv "${file_path}.tmp" "$file_path"

  echo "ensure_trailing_spaces $file_path done"
}

function clean_all_files() {
  for file_path in "${files[@]}"; do
    echo "Current item: $file_path"

    ensure_trailing_spaces "$file_path"
  done
}

action=$1
echo "."
if [[ "$#" -ne 1 ]]; then
	echo "no parameter inputted, default action to 'sync'"
  action="sync"	
fi

echo ".."
# ensure_trailing_spaces "./words/2025/words-Feb-25.md"

echo "..."

if [[ $action == 'sync' ]];
then
  echo -e "${GREEN}Update back words to origin files ${NC}" 
  pushBack

  echo -e "${GREEN}Clean up the WORDS_REVIEW file.${NC}"
  cat /dev/null > "$WORDS_REVIEW"

  # echo -e "${GREEN}Get new words for various resources to WORDS_REVIEW file.${NC}"
  getNewWords

  ensure_trailing_spaces "$WORDS_REVIEW"
elif [[ "$action" == 'countWords' ]]; then
  countWords
elif [[ "$action" == 'pushBack' || "$action" == 'push' ]]; then
  pushBack
elif [[ $action == 'update' ]]; then
  echo "Get new words."
  getNewWords
elif [[ $action == 'clean' ]]; then
  echo "Clean all files with trailing spaces"
  clean_all_files
else 
  echo -e "Action \"${action}\" ${RED}Failed!${NC}"
  echo "Action invalid, should be \"sync\", \"pushBack\", \"countWords\" or \"update\""
fi

