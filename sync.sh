
echo "" > word-review.md

ag '\*{2,}.*\s-{1,3}\W{0,10}$' --group --nonumbers > word-review.md

echo "\n\n ------- Second part ----- \n" >> word-review.md 
ag '\*{2,}.*\s-{2,3}\W{0,10}$' --group --nonumbers >> word-review.md

