FROM debian:jessie
MAINTAINER <peter.mcconnell@rehabstudio.com>

ENV DEBIAN_FRONTEND noninteractive

COPY ./app /usr/src/app
VOLUME /usr/src/app

# INSTALL CA-CERTS
RUN apt-get update
RUN apt-get install -y ca-certificates

# GCLOUD
RUN apt-get install -y -qq --no-install-recommends wget unzip python openssh-client python-openssl && apt-get clean
RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --disable-installation-options
RUN google-cloud-sdk/bin/gcloud --quiet components update pkg-go pkg-python pkg-java preview alpha beta app
RUN google-cloud-sdk/bin/gcloud --quiet config set component_manager/disable_update_check true
RUN mkdir /.ssh
ENV PATH /google-cloud-sdk/bin:$PATH
ENV HOME /

EXPOSE 8080
CMD gcloud auth activate-refresh-token $GCLOUD_ACCOUNT $GCLOUD_REFRESH && /usr/src/app/gocron/go-cron -s "0 0 1 * * *" -p 8080 -- /bin/bash -c "/usr/src/app/amald/amald_linux_64 -c=/usr/src/app/amald/config.yaml -t=/usr/src/app/amald/reports/tmpl/"