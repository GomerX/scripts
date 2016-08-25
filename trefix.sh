#!/bin/bash
# trefx.sh - give sane permissions to a tree, both directories and files.
# I usually do this as a BASH oneliner but I don't always remember the syntax.
# Now I don't need to remember.
# Usage: ./trefix.sh <directory>

for i in `find $1`;
  do
    if [ -d $i ] ;
      then
        chmod 775 $i;
    fi;

    if [ -f $i ] ;
      then
        chmod 664 $i;
    fi;
  done
