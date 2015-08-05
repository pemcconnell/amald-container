#AMALD (In a Docker container)

This repo is designed to allow you to run [amald](https://github.com/pemcconnell/amald) in a Docker container. This includes support for connecting to gcloud.

__note__: The version of amald contained in this repo is v0.0.4

### Environment variables
In order to connect to the gcloud cli (to retrieve information about your apps), this container expects two environment variables to be set:

- `GCLOUD_ACCOUNT` this expects your Google Cloud platform account (email address)
- `GCLOUD_REFRESH` this expects your Google Cloud platform refresh token. To retrieve this token, assuming your account is active, you can run `gcloud auth print-refresh-token`

### Instructions
- Ensure amald is correctly configured. You can view the config.yaml at `./app/amald/config.yaml`
- Build the container as you would normally. eg. `docker build -t="amald-container" .`
- Run the container, passing in the relevant environment variables. eg. `docker run -ti -e GCLOUD_ACCOUNT="me@domain.com" -e GCLOUD_REFRESH="123..." amald-container`

### Run script
The Docker command runs `./app/start.sh` which is worth investigating. One line to note reads (at the time of writing this README):

`/usr/src/app/gocron/go-cron -s "0 0 9 * * *" -p 8080 -- /bin/bash -c "/usr/src/app/amald/amald_linux_64 -configPath=/usr/src/app/amald/config.yaml`

This command runs go-cron with a predefined cron interval set to `0 0 9 * * *` - feel free to tweak this to suit your applications needs

### JSON output
Part of this container runs [go-cron](https://github.com/robfig/cron) which runs a local webserver. You can access the output of this webserver by looking at port 8080. An example of this output is:

```
{
  "Running": {},
  "Last": {
    "Exit_status": 0,
    "Stdout": "",
    "Stderr": "",
    "ExitTime": "",
    "Pid": 0,
    "StartingTime": ""
  },
  "Schedule": "0 0 1 * * *"
}
```

_note_: the above is a representation of the output when the cron is yet to run. More information is displayed once amald (or whatever the cron is tasked) has ran.

### Persistent data
Part of amalds reporting feature relies on the ability to compare current authentication states with previously ran results. This container is set to store results in `VOLUME /data` at `/data/data.json`. It is up to you want to do with this volume.
