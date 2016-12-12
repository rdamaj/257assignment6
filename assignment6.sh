#!/usr/bin/env bash

re1="\<d.*d\>"
re2="\ba\A*[a-zA-Z]\b"
re3="^[0-9]+$"
re4="(?:[0-9][^ ]*[A-Za-z][^ ]*)|(?:[A-Za-z][^ ]*[0-9][^ ]*)"

linecount=0
wordcount=0
ddcount=0
aacount=0
numcount=0
alphnumcount=0
mostWord=""
mostFreq=0
leastWord=""
leastFreq=0




filename=${1}
while read -r line
do
# increment count of total lines each time we start reading a new line
   linecount=$((linecount+1))
   
   words=${line}
   for word in $words
   do 

 # increment count of total words each time we look at a new word  
    wordcount=$((wordcount+1))

# initialize case-insensitivity for the regex
    shopt -s nocasematch
	if [[ $word =~ $re1 ]]; then
	    echo ' dd matching word: '$word
	    ddcount=$((ddcount+1))
	fi

    if [[ $word =~ $re2 ]]; then
	    echo ' aA matching word: '$word
	    aacount=$((aacount+1))
	fi
    if [[ $word =~ $re3 ]]; then
	    echo ' numeric matching word: '$word
	    numcount=$((numcount+1))
	fi
    if [[ $word =~ $re4 ]]; then
	    echo ' alphanumeric matching word: '$word
	    alphnumcount=$((alphnumcount+1))
	fi

    local mcount=1
    local lcount=1

# most-frequent word
    perl -nle '$mcount+=scalar(()=m/$word/g);END{print $mcount}' 
    if [[ "$mcount" -gt "$mostFreq" ]]; then
       mostWord=$word
       mostFreq=$mcount
    fi 

# least-frequent word
    perl -nle '$lcount+=scalar(()=m/$word/g);END{print $lcount}' 
    if [[ "$lcount" -eq 0]]; then
       leastWord=$word
       leastFreq=$lcount
    fi   
    if [[ "$lcount" -gt 0 && "$lcount" -lt "$leastFreq"]]; then
       leastWord=$word
       leastFreq=$lcount
    fi   

   done 
    

done < ${filename}

echo "Number of Lines : $linecount"
echo "Number of Words : $wordcount"
echo "Most repetitive word : $mostWord - $mostFreq appearances"
echo "lease repetitive word : $leastWord - $leastFreq appearances"
echo "Frequency of - Starts with d/D and ends with d/D : $ddcount"
echo "Frequency of - Starts with a/A and ends with any letter : $aacount"
echo "Frequency of numeric words : $numcount"
echo "Frequency of alphanumeric words : $alphnumcount"