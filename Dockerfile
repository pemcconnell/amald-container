FROM debian:jessie
MAINTAINER <peter.mcconnell@rehabstudio.com>

COPY ./app /usr/src/app

VOLUME /usr/src/app

EXPOSE 8080
CMD /usr/src/app/gocron/go-cron -s "*/10 * * * * *" -p 8080 -- /usr/src/app/amald/amald_linux_64 -c=/usr/src/app/amald/config.yaml
