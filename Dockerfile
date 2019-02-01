FROM debian:jessie

ENV CONTAINER=docker
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        python-pip \
        sudo \
        ca-certificates \
        software-properties-common \
        systemd systemd-cron sudo curl \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

RUN apt-add-repository 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main' \
    && apt-get update \
    && apt-get install -y wget \
    && apt-get install -y ansible \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean \
    && touch -m -t 201701010000 /var/lib/apt/lists/

RUN wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key \
    && apt-key add mosquitto-repo.gpg.key

RUN apt-get update && apt-get -y install apt-transport-https curl \
    && cd /etc/apt/sources.list.d \
    && wget http://repo.mosquitto.org/debian/mosquitto-jessie.list \
    && apt-get update -y

# Install Ansible inventory file.
RUN echo '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
