#!/bin/bash

path=`pwd`
rel="${path/`echo $HOME`/""}"
LATEST="8.1"

getPhpVersionDir() {
  if [ -f ".php-version" ]; then
    printf '%s\n' "${PWD}"
  elif [ "$PWD" = / ]; then
    # printf '%s\n' ""
    return
  else
    # a subshell so that we don't affect the caller's $PWD
    (cd .. && getPhpVersionDir )
  fi
}

getVersion() {
  echo $( cat "$1/.php-version" | head -1 )
}

phpversiondir=$( getPhpVersionDir )
# echo $phpversiondir

if [ ! "$phpversiondir" ]; then
  phpversion=$LATEST
else
  phpversion=$( getVersion $phpversiondir )
fi

if [ "$2" == "version" ]; then
  echo $phpversion
  exit 0
fi

container=`echo php"${phpversion/./""}"`

if [ ! "$phpversiondir" ]; then
  docker run --rm --network="container:${container}" -it -v $(pwd):/var/www/html "wodby/php:${phpversion}-dev" $@
else
  docker run --rm --network="container:${container}" -it -v "${phpversiondir}:/var/www/html" "wodby/php:${phpversion}-dev" $@
fi
