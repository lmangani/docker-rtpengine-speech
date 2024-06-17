FROM debian:12
USER root

RUN apt-get update && apt-get install -y sudo git make bison flex curl && \
    echo "mysql-server mysql-server/root_password password passwd" | sudo debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password passwd" | sudo debconf-set-selections && \
    apt-get install -y mysql-server libmysqlclient-dev \
                       libncurses5 libncurses5-dev mysql-client expect && \
    apt-get clean

RUN curl ipinfo.io/ip > /etc/public_ip.txt

RUN git clone https://github.com/OpenSIPS/opensips.git -b 3.4 ~/opensips_34 && \
    sed -i 's/db_http db_mysql db_oracle/db_http db_oracle/g' ~/opensips_34/Makefile.conf.template && \
    cd ~/opensips_34 && \
    make all && make prefix=/usr/local install && \
    cd .. && rm -rf ~/opensips_34

COPY /rtpengine /rtpengine
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -qqy dpkg-dev debhelper libevent-dev iptables-dev libcurl4-openssl-dev libglib2.0-dev libhiredis-dev libpcre3-dev libssl-dev libxmlrpc-core-c3-dev markdown zlib1g-dev module-assistant dkms gettext \
    libavcodec-dev libavfilter-dev libavformat-dev libjson-glib-dev libpcap-dev nfs-common \
    libbencode-perl libcrypt-rijndael-perl libdigest-hmac-perl libio-socket-inet6-perl libsocket6-perl netcat && \
    # ( ( apt-get install -y linux-headers-$(uname -r) linux-image-$(uname -r) && \
    #    module-assistant update && \
    #    module-assistant auto-install ngcp-rtpengine-kernel-source ) || true ) && \
    # ln -s /lib/modules/$(uname -r) /lib/modules/3.16.0 && \
    dpkg -i /rtpengine/*.deb && \
    #cp /lib/modules/$(uname -r)/extra/xt_RTPENGINE.ko /rtpengine/xt_RTPENGINE.ko && \
    apt-get clean

    
RUN apt-get purge -y bison build-essential ca-certificates flex git m4 pkg-config curl  && \
    apt-get autoremove -y && \
    apt-get install -y libmicrohttpd10 rsyslog ngrep && \
    apt-get clean

COPY conf/opensipsctlrc /usr/local/etc/opensips/opensipsctlrc
COPY conf/opensips-rtpengine.cfg /usr/local/etc/opensips/opensips.cfg
COPY rtpengine/rtpengine-recording.conf /etc/rtpengine/rtpengine-recording.conf

COPY boot_run.sh /etc/boot_run.sh
RUN chown root.root /etc/boot_run.sh && chmod 700 /etc/boot_run.sh

RUN apt install -y curl git && \
    curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash - && \
    apt-get install -y nodejs && \
    cd /opt && git clone https://github.com/QXIP/RTPEngine-Speech2Text && \
    cd RTPEngine-Speech2Text && npm install && npm install -g forever

EXPOSE 5060/udp
EXPOSE 5060/tcp
EXPOSE 9060/udp
EXPOSE 9060/tcp
EXPOSE 6060/udp
EXPOSE 20000-20100/udp

ENTRYPOINT ["/etc/boot_run.sh"]
