FROM debian:stretch-slim

ARG DEBIAN_FRONTEND=noninteractive

# add winswitch repository to install Xpra
RUN apt-get install curl
RUN curl http://winswitch.org/gpg.asc | apt-key add -
RUN echo "deb http://winswitch.org/ stretch main" > /etc/apt/sources.list.d/winswitch.list;

RUN apt-get update
RUN apt-get install xpra wireshark -y

#CMD ["wireshark"]
