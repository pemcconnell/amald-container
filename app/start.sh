#!/bin/bash

# Copy data
mkdir /data
if [ -f /data/data.json ]; 
then
	cp /usr/src/app/amald/data/data.json /data/data.json
fi

# Log into gcloud
gcloud auth activate-refresh-token $GCLOUD_ACCOUNT $GCLOUD_REFRESH

# Run cron
/usr/src/app/gocron/go-cron -s "0 0 1 * * *" -p 8080 -- /bin/bash -c "/usr/src/app/amald/amald_linux_64 -c=/usr/src/app/amald/config.yaml -t=/usr/src/app/amald/reports/tmpl/"