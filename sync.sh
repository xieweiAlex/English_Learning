#!/bin/bash 

function newWords {

  pattern="\*{2,}.*\s-{1,3}\W{0,10}$"
  target_file="words-new.md"

  echo "Hello World!  " > "$target_file"
  files=(
    "words/2019/words-Nov.md"
    "words/2019/words-Oct.md"
    "words/2019/words-Sep.md"
  )

  for file_path in "${files[@]}"
  do 
    echo -e "Checking file ${YELLOW} $file_path ${NC}"
    printf "\n ------------------------ Here is file divider ------------------------\n" >> "$target_file"
    ag "$pattern" -G "$file_path" --group --nonumbers >> "$target_file" 

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

# echo "" > word-review.md
# FILES=`ag -g .md`
# ONE_STAR='\*{2,}.*\s-{1,3}\W{0,10}$'

# echo $FILES
# NAMES=`"$FILES" | tr ' ' '\n'`

# echo '--------\n\n'
# echo $NAMES

# for i in "${FILES[@]}" 
# do
#   echo "$i" 
#   echo '-------------\n\n' 
#   # `ag -G './GOT/GOT5.md' 'You'` 
# done

# ag '\*{2,}.*\s-{1,3}\W{0,10}$' --group --nonumbers > word-review.md

# echo "" > words-selected.md
# head -70 word-review.md > words-selected.md   

# Sync new words 
# newWords

# update origin words file 
pushBack

# text="Hello trailing - "
# echo -e "$text"

