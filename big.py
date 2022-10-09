#!/usr/bin/env python
# a script to find the biggest directory recursively to identify heavy disk space usage
#


## import libraries. 
# subprocess -  handles calls to external programs, like BASH builtins
# re         -  does regular expressions.
import os
import subprocess
import re


## define a function
# find the biggest directory in the current directory and return it's size and name
def biggest():
    big = [0, ""]   # size and name of biggest directory

    # BASH command is fast and works. It's harder to do in Python
    this_dir = subprocess.check_output(["du", "-x", "--max-depth=1"])
    # break into lines
    dir_lines = this_dir.split("\n")
    # break into size/name pair
    for line in dir_lines:
        # look for the biggest subdirectory
        # the current directory is always biggest, so we don't count it. 
        # but it's the only line without a '/' so we skip it
        if re.search('/', line):
            size,name = line.split("./")
            size = int(size)
            if (size > big[0]):
                big[0] = size
                big[1] = name
    return big

## program starts here
# set baseline
prev = biggest()

while True: # infinite loop
    current = biggest()
    print ("largest directory is " + current[1] + " at " + str(current[0]) + "k bytes")

    # stop condition. If the biggest directory is less than half the size of the last on we checked, we are done
    if (current[0] < prev[0]/2):
        print ("stopping recursion here")
        break

    # descend into next directory
    os.chdir(os.getcwd() + "/"  + current[1])
    prev = current
