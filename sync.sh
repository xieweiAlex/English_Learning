#!/bin/bash 

# 2+ * & 1+ letter & .* & ends either 0 to 5 white space or line change  
PATTERN="\*{2,}[a-zA-Z]+.*-{1,3}(\s{0,5} | \n )$"
WORDS_REVIEW="words-new.md"

function getNewWords {

  echo "Hello World!  " > "$WORDS_REVIEW"
  files=(
    "GOT/GOT4.md"
    "GOT/GOT5.md"
    "GOT/GOT6.md"
    "words/2019/words-Nov.md"
    "words/2019/words-Oct.md"
    "words/2019/words-Sep.md"
    "words/2019/words-Aug.md"
    "words/2019/words-July.md"
  )

  for file_path in "${files[@]}"
  do 
    echo -e "Checking file: ${YELLOW} $file_path ${NC}"
    file_name=$(basename "$file_path")
    echo "" >> "$WORDS_REVIEW"
    echo "## ----------- ${file_name} -----------  " >> "$WORDS_REVIEW"
    ag "$PATTERN" -G "$file_path" --group --nonumbers >> "$WORDS_REVIEW" 

  done 

  # Delete lines (120,$) let's keep the review short & lean  
  sed -i '' '121, 500d' "$WORDS_REVIEW"

}

function pushBack {

  # record the current file_name
  file_name=""
  while read -r line; do
    if [[ $line == *md ]] && [[ -f $line ]]; 
    then 
      file_name=$line
      echo -e " ${YELLOW} $file_name ${NC}"
    fi

    if ! [[ -f $file_name ]]; then 
      echo "No file_name line reached yet, it's fine, next line please."
      continue
    fi

    # trim ending white spaces  
    trimmedStr=$(echo "$line" | sed 's/ *$//g')

    # if trimmed_str contains "**{char}**" && not end in -  
    if [[ $trimmedStr =~ \*\*[a-zA-Z]*\*\*  ]] && ! [[ $trimmedStr =~ -$ ]]; 
    then 
      echo -e "Update sentence: ${GREEN} $trimmedStr ${NC}" 
      # escape from "*" to "\*" to help sed search/replace  
      escapedStr=$(echo "$trimmedStr" | sed 's/\*/\\*/g')
      # find from the $file_name and replace the original str with updated string(two white space in the end) from words-review 
      sed -i '' "s/$escapedStr.*/$trimmedStr  /" "$file_name"
    fi
  done <$WORDS_REVIEW
}


action=$1

echo "."
if [[ "$#" -ne 1 ]]; then
	echo "no parameter inputted, will be default to 'sync'"
    action="sync"	
	echo ""
fi

echo ".."
if [[ $action == 'sync' ]];
then
  # Update words files from words-new
  echo "Update back words to origin files " 
  pushBack
  # Get new words to words-new
  echo "get new words"
  getNewWords
elif [[ $action == 'pushBack' ]]; 
then
  pushBack
elif [[ $action == 'update' ]]; 
then
  echo "Get new words."
  getNewWords
else 
  echo -e "${RED}Failed!${NC}"				
	echo "this is invalid parameter: $action"		
	echo "should be \"sync\" or \"update\""
fi



