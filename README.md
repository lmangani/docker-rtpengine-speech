<img src="https://avatars1.githubusercontent.com/u/3853758?v=4&s=100">

# OpenSIPS + RTPEngine Speech Recognition
This repository provides a proof-of-concept OpenSIPS/RTPEngine/HEP contraption, capable of SIP/RTP recording and Speech-to-Text conversion using external APIs shipped as HEP Logs to HOMER/HEPIC, not to be used for any production purpose what-so-ever.

< img src="https://i.imgur.com/SLjsWr7.png" />

<!--
### Quick Start
Automated builds of the image are available on [DockerHub](https://hub.docker.com/r/qxip/homer-hepswitch)
```sh
$ docker pull qxip/docker-rtpengine-record
```
-->

### Custom Build w/ RTPEngine kernel modules
In order for RTPEngine to insert and use its kernel recording modules on a given system, the container must be built for the specific OS kernel w/ corresponding modules, etc.
```
git clone https://github.com/lmangani/docker-rtpagent-record
cd docker-rtpagent-record
docker build -t qxip/docker-rtpengine-record .
```

### Usage
Use docker-compose to manage the containerïstatus¼š
```sh
$ docker-compose up
```
Call relay is enabled on this dev image, so all calls will be forwarded in proxy mode
