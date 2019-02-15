#!/usr/bin/env python
# a script to find the biggest directory recursively to identify heavy disk space usage
#

import os
import subprocess
import re

# find the biggest directory in the current directory and return it's size and name
def biggest():
    big = [0, ""]

    # BASH command is fast and works. It's harder to do in Python
    this_dir = subprocess.check_output(["du", "-x", "--max-depth=1"])
    # break into lines
    dir_lines = this_dir.split("\n")
    # break into size/name pair
    for y in dir_lines:
        # this avoids current directory  which has no '/'
        if re.search('/', y):
            s,n = y.split("./")
            s = int(s)
            if (s > big[0]):
                big[0] = s
                big[1] = n
    return big

# set baseline
prev = biggest()

while True:
    current = biggest()
    print "largest directory is " + current[1] + " at " + str(current[0])
    if (current[0] < prev[0]/2):
        print "stopping recursion here"
        break
    os.chdir(os.getcwd() + "/"  + current[1])
    prev = current
