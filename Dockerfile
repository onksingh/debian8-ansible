FROM debian:jessie

ENV CONTAINER=docker
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils \
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

# Install Ansible inventory file.
RUN echo '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
