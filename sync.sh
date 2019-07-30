
echo "" > word-review.md
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

ag '\*{2,}.*\s-{1,3}\W{0,10}$' --group --nonumbers > word-review.md

echo "" > words-selected.md
head -70 word-review.md > words-selected.md   
 



