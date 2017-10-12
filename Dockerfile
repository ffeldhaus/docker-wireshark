FROM debian:stretch-slim

LABEL version="0.3"
LABEL maintainer="florian.feldhaus@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive

# add winswitch repository to install Xpra
RUN apt-get update
RUN apt-get install gnupg curl -y
RUN curl http://xpra.org/gpg.asc | apt-key add -
RUN echo "deb http://xpra.org/beta/ stretch main" > /etc/apt/sources.list.d/xpra.list;
RUN echo "deb http://xpra.org/ stretch main" >> /etc/apt/sources.list.d/xpra.list;

# install wireshark and xpra to make wirehsark available via websocket
RUN apt-get update
RUN apt-get install -y --no-install-recommends xpra wireshark websockify libjs-jquery

# allow non-root users to capture network traffic
RUN setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/dumpcap

# copy xpra config file
COPY ./xpra.conf /etc/xpra/xpra.conf

# use docker-entrypoint.sh to allow passing options to xpra and start xpra from bash
COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# create run directory for xpra socket and set correct permissions
RUN mkdir -p /run/user/1000/xpra
RUN chown -R 1000 /run/user/1000

# add wireshark user
RUN useradd --create-home --shell /bin/bash wireshark --groups xpra --uid 1000
USER wireshark
WORKDIR /home/wireshark

# create self-signed SSL certificate and key
RUN openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 --nodes -subj "/CN=example.org"

# expose xpra default port
EXPOSE 14500

# set default password to access wireshark
ENV XPRA_PW wireshark

# run xpra, options --daemon and --no-printing only work if specified as parameters to xpra start
CMD ["/usr/bin/xpra","start","--daemon=no","--no-printing"]
