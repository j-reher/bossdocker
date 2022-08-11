#!/bin/bash

printf "Begin processing!\n"
while IFS="" read -r p || [ -n "$p" ]
do
    printf 'Processing Version \"%s\"\n' "$p";
done <versions.txt
printf "End processing!\n"