FROM debian:12
USER root

RUN apt-get update && apt-get install -y sudo git make bison flex curl && \
    echo "mysql-server mysql-server/root_password password passwd" | sudo debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password passwd" | sudo debconf-set-selections && \
    apt-get install -y mariadb-server mariadb-client libmariadb-dev \
                       libncurses5 libncurses5-dev expect wget \
		       gnupg lsb-release libmariadb-dev-compat && \
    apt-get clean

RUN curl ipinfo.io/ip > /etc/public_ip.txt

RUN git clone https://github.com/OpenSIPS/opensips.git -b 3.4 ~/opensips_34 && \
    sed -i 's/db_http db_mysql db_oracle/db_http db_oracle/g' ~/opensips_34/Makefile.conf.template && \
    cd ~/opensips_34 && \
    make all && make prefix=/usr/local install && \
    cd .. && rm -rf ~/opensips_34

RUN wget https://rtpengine.dfx.at/latest/pool/main/r/rtpengine-dfx-repo-keyring/rtpengine-dfx-repo-keyring_1.0_all.deb && \
	dpkg -i rtpengine-dfx-repo-keyring_1.0_all.deb && \
	echo "deb [signed-by=/usr/share/keyrings/dfx.at-rtpengine-archive-keyring.gpg] https://rtpengine.dfx.at/latest bookworm main" | sudo tee /etc/apt/sources.list.d/dfx.at-rtpengine.list && \
	apt install -y rtpengine && \
	apt clean
    
RUN apt-get purge -y bison build-essential ca-certificates flex git m4 pkg-config curl  && \
    apt-get autoremove -y && \
    apt-get install -y  rsyslog ngrep && \
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
