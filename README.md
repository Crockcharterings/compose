Docker Compose
==============
*(Previously known as Fig)*

Compose is a tool for defining and running complex applications with Docker.
With Compose, you define a multi-container application in a single file, then
spin your application up in a single command which does everything that needs to
be done to get it running.

Compose is great for development environments, staging servers, and CI. We don't
recommend that you use it in production yet.

Using Compose is basically a three-step process.

First, you define your app's environment with a `Dockerfile` so it can be
reproduced anywhere:

```Dockerfile
FROM hypriot/rpi-python:latest
WORKDIR /code
ADD requirements.txt /code/
RUN pip install -r requirements.txt
ADD . /code
CMD python app.py
```

Next, you define the services that make up your app in `docker-compose.yml` so
they can be run together in an isolated environment:

```yaml
web:
  build: .
  links:
   - db
  ports:
   - "8000:8000"
db:
  image: hypriot/rpi-redis
```

Lastly, run `docker-compose up` and Compose will start and run your entire app.

Compose has commands for managing the whole lifecycle of your application:

 * Start, stop and rebuild services
 * View the status of running services
 * Stream the log output of running services
 * Run a one-off command on a service

Installation and documentation
------------------------------

To install Compose on Raspberry Pi with an installation of the [HypriotOS SD card image including Docker 1.6 or newer](http://blog.hypriot.com/downloads/), run the following commands:

```bash
curl -L https://github.com/hypriot/compose/releases/download/1.2.0-raspbian/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose
```

- Full documentation is available on [Docker's website](http://docs.docker.com/compose/).
- Hop into #docker-compose on Freenode if you have any questions.

Contributing
------------

[![Build Status](http://jenkins.dockerproject.com/buildStatus/icon?job=Compose Master)](http://jenkins.dockerproject.com/job/Compose%20Master/)

Want to help build Compose? Check out our [contributing documentation](https://github.com/docker/compose/blob/master/CONTRIBUTING.md).
