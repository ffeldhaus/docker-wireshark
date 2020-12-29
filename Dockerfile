FROM ffeldhaus/xpra-html5-minimal

LABEL version="1.0"
LABEL maintainer="florian.feldhaus@gmail.com"

# skip interactive configuration dialogs
ENV DEBIAN_FRONTEND noninteractive

# add winswitch repository and install Xpra
RUN apt-get update && \
    apt-get install -y wireshark && \
    # binutils are necessary to use strip utility
    apt-get install -y --no-install-recommends binutils && \
    # this is required due to incompatibilities on Centos 7 hosts see issue #4 for details
    ldconfig -p | grep libQt5Core.so.5 | cut -d '>' -f 2 | xargs -I{} strip --remove-section=.note.ABI-tag {} && \
    apt-get remove -y --purge binutils && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/*

# allow non-root users to capture network traffic
RUN setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/dumpcap

# set default password to access wireshark
ENV XPRA_PASSWORD wireshark

# start wireshark by default
CMD ["wireshark --fullscreen"]
