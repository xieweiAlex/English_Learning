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

function update_origin_words {
  origin_file="words-new.md"

  # cat $origin_file
  while read -r line; do
    # string=$(echo "$line" | xargs)
    string=$(awk '{$line=$line;print}')
    echo $string

    # if ! [[ $string == .*_ ]]
    # then 
    #   echo "$string"
    # fi 
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
newWords

# update origin words file 
# update_origin_words

# text="Hello trailing - "
# echo -e "$text"
