#!/bin/sh

INPUT=$PARAMETERS
echo input: $INPUT  

COUNTER=0
IN=""
OUT=""
for parameter in $INPUT
do
    if [ $COUNTER -eq 0 ]; then
      IN=$parameter
    fi
    if [ $COUNTER -eq 1 ]; then
      OUT=$parameter
      echo "Starting ${OUT} stream"
      $(sh ./create_ffmpeg_cmd.sh ${IN} ${OUT}) &
      cp viewer.template ${OUT}.html
      sed -i 's/<view_name>/'${OUT}'/g' ${OUT}.html
      mv ${OUT}.html /usr/share/nginx/html/
      COUNTER=0
      IN=""
      OUT=""
      continue
    fi
    COUNTER=$((COUNTER+1))
done

nginx -g "daemon off;"
