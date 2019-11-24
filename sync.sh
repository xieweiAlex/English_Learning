#!/bin/bash 

function getNewWords {

  pattern="\*{2,}.*\s-{1,3}\W{0,10}$"
  target_file="words-new.md"

  echo "Hello World!  " > "$target_file"
  files=(
    "GOT/GOT6.md"
    "words/2019/words-Nov.md"
    "words/2019/words-Oct.md"
    "words/2019/words-Sep.md"
  )

  for file_path in "${files[@]}"
  do 
    echo -e "Checking file ${YELLOW} $file_path ${NC}"
    printf "\n ## ------------------------ Here is file divider ------------------------\n" >> "$target_file"
    ag "$pattern" -G "$file_path" --group --nonumbers >> "$target_file" 

    words=$(cat "$target_file" | head -100 )
    echo "$words" > "$target_file"
  done 
}

function pushBack {
  origin_file="words-new.md"

  # record the current file_name
  file_name=""
  while read -r line; do
    if [[ $line == words*  ]] && [[ $line == *md ]]; 
    then 
      file_name=$line
      echo -e " ${YELLOW} $file_name ${NC}"
    fi

    str=$(echo "$line" | sed 's/ *$//g')

    # if str contains "**{char}**" and not ended in -  
    if [[ $str =~ \*\*.*\*\*  ]] && ! [[ $str == *- ]]; 
    then 
      echo -e "Update text: ${GREEN} $str ${NC}" 
      escapedStr=$(echo "$str" | sed 's/\*/\\*/g')
      sed -i '' "s/$escapedStr.*/$str/" "$file_name"
    fi
  done <$origin_file
}

action=$1

if [[ "$#" -ne 1 ]]; then
	echo "no parameter inputted, will be default to 'sync'"
    action="sync"	
	echo ""
fi

echo ".."
if [[ $action == 'sync' ]];
then
  # Update words files from words-new
  echo "Update back words to origin files" 
  pushBack
  # Get new words to words-new
  echo "get new words"
  getNewWords

elif [[ $action == 'update' ]]; 
then
  echo "get new words"
  getNewWords
else 
  echo -e "${RED}Failed!${NC}"				
	echo "this is invalid para: $action"		
	echo "should be \"sync\" or \"disp\""
fi


# # Sync new words 
# # getNewWords
# # update origin words file 
# pushBack
# # text="Hello trailing - "
# # echo -e "$text"

