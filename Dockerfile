FROM debian:stretch

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils vim xterm pulseaudio cups curl

ENV NOMACHINE_PACKAGE_NAME nomachine_6.4.6_1_amd64.deb
ENV NOMACHINE_MD5 6623e37e88b4f5ab7c39fa4a6533abf4

RUN apt-get install -y mate-desktop-environment-core 

RUN curl -fSL "http://download.nomachine.com/download/6.4/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
  && echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - \
  && dpkg -i nomachine.deb \
  && groupadd -r nomachine -g 433 \
  && useradd -u 431 -r -g nomachine -d /home/nomachine -s /bin/bash -c "NoMachine" nomachine \
  && mkdir /home/nomachine \
  && chown -R nomachine:nomachine /home/nomachine \
  && echo 'nomachine:nomachine' | chpasswd

ADD nxserver.sh /
ADD nxserverlog.sh /

RUN ./nxserver.sh

# Specify the user as whom we should be running as.
USER nomachine

ENTRYPOINT ["/nxserverlog.sh"]
