FROM ubuntu:16.04

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

RUN apt-get update && \
    apt-get install -y vim curl wget python-software-properties apt-transport-https apt-utils dialog less module-init-tools locales logrotate jq && \
    locale-gen en_US.UTF-8 && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.UTF-8
#ENV LC_ALL en_US.UTF-8

RUN wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add - && \
    echo deb https://download.ceph.com/debian-luminous/ $(lsb_release -sc) main | tee /etc/apt/sources.list.d/ceph.list && \
    apt-get update && \
    apt-get install -y ceph-common=12.2.1-1xenial && \
    rm -rf /var/lib/apt/lists/*

#    apt-get install -y ceph-osd ceph-mds ceph-mon radosgw rbd-fuse ceph-fuse && \

ADD scripts/ /usr/bin/
ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start.sh","storage","--driver-name","rancher-rbd"]
