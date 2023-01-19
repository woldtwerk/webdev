#!/bin/bash

path=`pwd`
# rel="${path/`echo $HOME`/""}"
rel="${PWD}"
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

if [ "$1" == "phpunit" ]; then
  echo $SIMPLETEST_BASE_URL
  echo $SIMPLETEST_DB
  docker run --rm --network=host --env SIMPLETEST_BASE_URL --env SIMPLETEST_DB -it -w $rel -v $HOME/Sites:${HOME}/Sites -v $HOME/.config/composer/:/home/wodby/.composer/ "wodby/php:${phpversion}-dev" /bin/bash
else
  container=`echo php"${phpversion/./""}"`
  docker exec -w $rel $container $@
fi

# if [[ $rel == /Sites/* ]]; then
#   docker exec -w $rel $container $@
# else
#   if [ ! "$phpversiondir" ]; then
#     docker run --rm --network="container:${container}" -it -v $(pwd):/var/www/html -v $HOME/.config/composer/:/home/wodby/.composer/ -v $HOME/.ssh/:/home/wodby/.ssh/ "wodby/php:${phpversion}-dev" $@
#   else
#     docker run --rm --network="container:${container}" -it -v "${phpversiondir}:/var/www/html" -v $HOME/.config/composer/:/home/wodby/.composer/ -v $HOME/.ssh/:/home/wodby/.ssh/ "wodby/php:${phpversion}-dev" $@
#   fi
# fi