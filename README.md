<img src="https://avatars1.githubusercontent.com/u/3853758?v=4&s=100">

# OpenSIPS + RTPEngine + HEP Speech Recognition
This repository provides a proof-of-concept OpenSIPS/RTPEngine/HEP contraption, capable of SIP/RTP recording and Speech-to-Text conversion using external APIs shipped as HEP Logs to HOMER/HEPIC, not to be used for any production purpose what-so-ever.

For a full explanation, check this post on the [OpenSIPS Blog](https://blog.opensips.org/2018/02/16/audio-recording-and-speech-detection-experiments-with-opensips/)

<img src="https://i.imgur.com/SLjsWr7.png" />

<!--
### Quick Start
Automated builds of the image are available on [DockerHub](https://hub.docker.com/r/qxip/homer-hepswitch)
```sh
$ docker pull qxip/docker-rtpengine-speech
```
-->

### Custom Build w/ RTPEngine kernel modules
In order for RTPEngine to insert and use its kernel recording modules on a given system, the container must be built for the specific underlying OS kernel version. Please use the ```dev``` branch to produce a source-compiled build.
```
git clone https://github.com/lmangani/docker-rtpagent-speech
cd docker-rtpagent-speech
docker build -t qxip/docker-rtpengine-speech .
```

### Usage
Use docker-compose to manage the container status
```sh
$ docker-compose up
```
Call relay is enabled on this dev image, so all calls will be forwarded in proxy mode
