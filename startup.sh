#!/bin/sh

INPUT=$PARAMETERS
echo input: $INPUT  

COUNTER=0
IN=""
OUT=""

mkdir /usr/share/nginx
mkdir /usr/share/nginx/html

for parameter in $INPUT
do
    if [ $COUNTER -eq 0 ]; then
      IN=$parameter
    fi
    if [ $COUNTER -eq 1 ]; then
      OUT=$parameter
      echo "Starting ${OUT} stream"
      $(sh ./create_ffmpeg_cmd.sh ${IN} ${OUT}) &
      cp -f viewer.template ${OUT}.html
      sed -i 's/<view_name>/'${OUT}'/g' ${OUT}.html
      mv -f ${OUT}.html /usr/share/nginx/html/
      echo '<a href="/static/'${OUT}'.html">'${OUT}'</a><BR>' >>index_link.template
      COUNTER=0
      IN=""
      OUT=""
      continue
    fi
    COUNTER=$((COUNTER+1))
done

#create index.html with all links to video stream pages
rm index.html
cat index_top.template >> index.html
cat index_link.template >> index.html
cat index_bottom.template >> index.html
mv -f index.html /usr/share/nginx/html/
rm index_link.template

nginx -g "daemon off;"
