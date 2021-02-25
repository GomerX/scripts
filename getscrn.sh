#!/bin/bash
# Tells mme what screens sessions are running and allows me to pick one to attach.

# Most of the work is here. Replacing spaces with dashes isn't perfect, but it
# saves me some work stiching everything back together after breaking lines on
# spaces.
screens=(`screen -ls | grep -E 'Detached|Attached' | tr [:blank:] _ | cut -d _ -f2-`)

line=1
for i in "${screens[@]}"
	do echo $line "$i"
	line=$(($line + 1))
done
# Get user choice
read -p 'Attach which session? ' response
# Arrays are indexed from zero
response=$((response - 1))
chosen="${screens[$response]}"
chosen=`echo ${screens[$response]} | cut -d _ -f1`
screen -dRa $chosen
