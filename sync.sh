
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

pattern="\*{2,}.*\s-{1,3}\W{0,10}$"
target_file="words-new.md"

echo "Hello World!  " > "$target_file"
files=(
  "words/2019/words-Oct.md"
  "words/2019/words-Sep.md"
)

for file_path in "${files[@]}"
do 
  echo "Checking file $file_path"
  echo "\n ------------------------ Here is file divider ------------------------\n" >> "$target_file"
  ag "$pattern" -G "$file_path" --group --nonumbers >> "$target_file" 

done 


