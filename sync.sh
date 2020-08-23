#!/bin/bash 

source "./variable.sh"

# 2+ * & 1+ letter & .* & ends either 0 to 5 white space or line change  
PATTERN="\*{2,}[a-zA-Z]+.*-{1,3}(\s{0,5} | \n )$"

# test_file="./media/houseOfCards/HOC1.md"
function countWords {

  total_count=0
  for file_path in "${files[@]}"; do 
    echo "path: $file_path"
    while read -r line; do
      count=$(./count.py "$line")
      # echo "count: $count"
      total_count=$(( total_count + count ))
    done <"$file_path"

    echo "total count: $total_count"
  done 

}

function getNewWords {
  for file_path in "${files[@]}"
  do 
    echo -e "Checking file: ${YELLOW} $file_path ${NC}"
    file_name=$(basename "$file_path")
    file_content=$(ag "$PATTERN" -G "$file_path" --group --nonumbers | sed '/^[[:space:]]*$/d') 

    if [ -n "$file_content" ]; then 
      # firstLine=$(echo "$file_content" | head -1 ) 
      # sed -i '' "1s/.*/##Test" "$file_content"
      echo "" >> "$WORDS_REVIEW"
      echo "## ${file_name} ## " >> "$WORDS_REVIEW"
      echo "$file_content" >> "$WORDS_REVIEW"
    fi
  done 

  length=$(cat $WORDS_REVIEW | wc -l)
  echo -e "File length: ${YELLOW} $length ${NC}, cut off lines beyond 110!"
  # Delete lines (111,$) let's keep the review file short & lean  
  sed -i '' '111, 500d' "$WORDS_REVIEW"
}

function pushBack {
  # 1. pushBack  
  # record the current file_name
  file_name=""
  lineNum=0
  lines=""
  while read -r line; do
    lineNum=$(( lineNum + 1 ))
    if [[ $line == *md ]] && [[ -f $line ]]; then 
      file_name=$line
      echo -e " Push back file: ${YELLOW} $file_name ${NC}"
    fi

    if ! [[ -f $file_name ]]; then 
      echo "No file_name line yet, next line please."
      continue
    fi

    # trim ending white spaces  
    trimmedStr=$(echo "$line" | sed 's/ *$//g')

    # if trimmed_str contains "**{char}**" && not end in -  
    if [[ $trimmedStr =~ \*\*.+\*\*  ]] && ! [[ $trimmedStr =~ -$ ]]; then 

      echo -e "Update sentence: ${GREEN} $trimmedStr ${NC}, line: $lineNum" 
      
      # lines="$lines" + "$lineNum" + "d"
      lines+="$lineNum""d;"

      # escape from "*" to "\*" to help sed search/replace  
      escapedStr=$(echo "$trimmedStr" | sed 's/\*/\\*/g')
      # find from the $file_name and replace the original str with updated string(two white space in the end) from words-review 
      sed -i '' "s/$escapedStr.*/$trimmedStr  /" "$file_name"
    fi

  done <$WORDS_REVIEW

  # echo lines 
  echo "We got line: $lines"
  cleanWordReview $lines
}

function cleanWordReview {

  echo "Purge the file $WORDS_REVIEW"
  lines=$1

  # lines="14d;15d;16d;"
  sed -i '' "$lines" $WORDS_REVIEW

  # for line in $(echo "$lines" | tr " " "\n")
  # do
  #   echo "Line: $line"
  #   sed -i '' "$line"'d' $WORDS_REVIEW 
  # done
}


action=$1

echo "."
if [[ "$#" -ne 1 ]]; then
	echo "no parameter inputted, default action to 'sync'"
  action="sync"	
fi

echo ".."
if [[ $action == 'sync' ]];
then
  echo -e "${GREEN}Update back words to origin files ${NC}" 
  pushBack

  echo -e "${GREEN}Clean up the WORDS_REVIEW file.${NC}"
  echo "" > "$WORDS_REVIEW"

  echo -e "${GREEN}Get new words for various resources to WORDS_REVIEW file.${NC}"
  getNewWords
elif [[ "$action" == 'countWords' ]]; then
  countWords
elif [[ "$action" == 'pushBack' || "$action" == 'push' ]]; then
  pushBack
elif [[ $action == 'update' ]]; then
  echo "Get new words."
  getNewWords
else 
  echo -e "${RED}Failed!${NC}"				
	echo "this is invalid parameter: $action"		
	echo "should be \"sync\", \"pushBack\" or \"update\""
fi



