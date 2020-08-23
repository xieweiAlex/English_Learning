#!/usr/bin/python3

import sys 
import re
import os

line = sys.argv[1]
# line = "the feature **bloated** IDE Emacs is rather **off-putting**"
# line = "**bloated** IDE Emacs is"
# line = "asdfasdf asdf sad fasdf as dfasd f"
# print ('The line is: ', line)

pattern = "\*\*[^*]*\*\*"
matches = re.findall(pattern, line)
# print("the matches is: ", matches)
count = len(matches)
print(count)
# os._exit(count)



