FROM ubuntu:20.04

MAINTAINER Emilien GARNIER <mimilster@gmail.com>

ARG ARCHI_USER=archi

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y sudo curl unzip libgtk-3-dev dbus-x11 xvfb git sshpass lftp && apt-get clean

RUN curl -o /archi.tar.gz https://www.archimatetool.com/downloads/21da7fac18f/Archi-Linux64-4.6.0.tgz
RUN tar -zxvf /archi.tar.gz
RUN rm /archi.tar.gz

RUN curl -o /archi-git.zip https://www.archimatetool.com/downloads/coarchi/org.archicontribs.modelrepository_0.6.2.202004031233.archiplugin
RUN unzip /archi-git.zip -d /Archi/plugins -x archi-plugin
RUN rm /archi-git.zip

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/$ARCHI_USER && \
    echo "$ARCHI_USER:x:${uid}:${gid}:$ARCHI_USER,,,:/home/$ARCHI_USER:/bin/bash" >> /etc/passwd && \
    echo "$ARCHI_USER:x:${uid}:" >> /etc/group && \
    echo "$ARCHI_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$ARCHI_USER && \
    chmod 0440 /etc/sudoers.d/$ARCHI_USER && \
    chown ${uid}:${gid} -R /home/$ARCHI_USER

COPY archi.sh /usr/local/bin/archi
RUN chmod +x /usr/local/bin/archi

USER $ARCHI_USER
ENV HOME /home/$ARCHI_USER

WORKDIR /home/$ARCHI_USER

CMD ["archi", "--help"]
