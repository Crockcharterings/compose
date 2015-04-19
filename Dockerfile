FROM resin/rpi-raspbian:wheezy

RUN set -ex; \
    apt-get update -qq; \
    apt-get install -y \
        python \
        python-pip \
        python-dev \
        git \
        apt-transport-https \
        ca-certificates \
        curl \
        lxc \
        iptables \
    ; \
    rm -rf /var/lib/apt/lists/*

ENV ALL_DOCKER_VERSIONS 1.6.0-rc4

RUN set -ex; \
    curl https://test.docker.com/builds/Linux/x86_64/docker-1.6.0-rc4 -o /usr/local/bin/docker-1.6.0-rc4; \
    chmod +x /usr/local/bin/docker-1.6.0-rc4

# Set the default Docker to be run
RUN ln -s /usr/local/bin/docker-1.6.0-rc4 /usr/local/bin/docker

RUN useradd -d /home/user -m -s /bin/bash user
WORKDIR /code/

ADD requirements.txt /code/
RUN pip install -r requirements.txt

ADD requirements-dev.txt /code/
RUN pip install -r requirements-dev.txt

RUN apt-get install -qy wget && \
    wget -q https://pypi.python.org/packages/source/P/PyInstaller/PyInstaller-2.1.tar.gz && \
    tar xzf PyInstaller-2.1.tar.gz && \
    cd PyInstaller-2.1/bootloader && \
    python ./waf configure --no-lsb build install && \
    ln -s /code/PyInstaller-2.1/PyInstaller/bootloader/Linux-32bit-arm /usr/local/lib/python2.7/dist-packages/PyInstaller/bootloader/Linux-32bit-arm

ADD . /code/
RUN python setup.py install

RUN chown -R user /code/

ENTRYPOINT ["/usr/local/bin/docker-compose"]
