# FROM alpine:3.7  — updated this to latest.
FROM alpine:latest

# Install nginx and ffmpeg
RUN apk add --update nginx ffmpeg && rm -rf /var/cache/apk/* && mkdir /tmp/stream

COPY ./startup.sh /
COPY ./create_ffmpeg_cmd.sh /
COPY ./*.template /

#copy any content we have created
#copy ./*.html /usr/share/nginx/html/
#copy ./*.css /usr/share/nginx/html/
#copy ./*.png /usr/share/nginx/html/
#copy ./*.js /usr/share/nginx/html/

RUN ["chmod", "+x", "/startup.sh"]
RUN ["chmod", "+x", "/create_ffmpeg_cmd.sh"]

COPY nginx/nginx.conf /etc/nginx/nginx.conf

CMD ["/startup.sh"]
