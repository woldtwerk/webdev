#!/bin/bash

path=`pwd`
rel="${path/`echo $HOME`/""}"
FILE=.php-version
phpversion="8.1"
pattern=^[7-8]\.[0-9]$

if [ -f "$FILE" ]; then
  tmp=`cat $FILE`
  if [[ "$tmp" =~ $pattern ]]; then
    phpversion=${BASH_REMATCH[0]}
  fi
fi 

container=`echo php"${phpversion/./""}"`

docker exec -it -w $rel $container $@