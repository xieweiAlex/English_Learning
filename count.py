#!/usr/bin/python3

import sys 
import re
import os

file_path = sys.argv[1]

file = open(file_path,mode='r')
content = file.read()
file.close()

pattern = "\*\*[^*]*\*\*"
matches = re.findall(pattern, content)
count = len(matches)
print(count)
# os._exit(count)

