# LocomotiveCMS Engine in a Docker container

This is a Docker configuration for running [LocomotiveCMS Engine v3.1.1](https://github.com/locomotivecms/engine) in a Docker container. Two containers, actually: one for the [MongoDB image](https://hub.docker.com/r/_/mongo/), and another for Locomotive Engine. Uses [Docker Compose](https://docs.docker.com/compose/) to run.

## Usage

```
git clone git@github.com:brentkearney/docker-locomotive.git
cd docker-locomotive
docker-compose up
```

The first time you run, the database and configuration files will be generated. Take note of the output, ^C to quit, edit the config files as necessary. Start with `docker-compose up -d` when you are ready to run it in the background.


