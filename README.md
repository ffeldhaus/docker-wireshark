# Wireshark Web Container Image

Docker image which makes Wireshark available via Web browser using XPRA.

## Usage

Run wireshark container. By default port 14500 will be used. Change docker port mapping to a different port if required (e.g. 5432/14500).

By default it should be sufficient to use the parameter `--sec-add NET_ADMIN` to allow Wireshark to capture traffic, but if Wireshark does not show any interfaces for capturing or shows permission errors, docker must be run with the parameter `--privileged` which grants extended privileges to the container but should be avoided if possible for security reasons.

By default, the container uses the default self-signed certificate to offer SSL. If you want to specify your own certificate, you can overwrite the default SSL certificate with the docker parameter similar to `--mount type=bind,source="$(pwd)"/ssl-cert.pem,target=/etc/xpra/ssl-cert.pem,readonly` (make sure to put the ssl-cert.pem file in the current folder or modify the source path).

By default, Wireshark can only be accessed using a password. The default password is `wireshark`, but can be changed by setting the environment variable XPRA_PW.

It is useful to automatically restart the container on failures using the `--restart unless-stopped` parameter.

If you only want to analyze existing network traces and not collect data from network interfaces, use
```bash
docker run -p 14500:14500 --restart unless-stopped --name wireshark ffeldhaus/wireshark
```

If you wish to analyze traffic from network devices, you should use

```bash
docker run -p 14500:14500 --restart unless-stopped --name wireshark --cap-add NET_ADMIN ffeldhaus/wireshark
```

If that didn't work, it may be necessary to start the container as priviliged

```bash
docker run -p 14500:14500 --restart unless-stopped --name wireshark --privileged ffeldhaus/wireshark
```

To allow analyzing traffic of netwrok devices, change the password to connect and provide a custom SSL certificate, use

```bash
docker run -p 14500:14500 --restart unless-stopped --name wireshark --cap-add NET_ADMIN -e XPRA_PW=mypassword --mount type=bind,source="$(pwd)"/ssl-cert.pem,target=/etc/xpra/ssl-cert.pem,readonly ffeldhaus/wireshark
```

Access Wireshark via the browser using the IP/Hostname of your docker host and providing username and password (change password=wireshark if you provided a different password) using e.g.

    https://<yourhostname>:14500/?username=wireshark&password=wireshark

If you want to allow to share your session, use

    https://<yourhostname>:14500/?username=wireshark&password=wireshark&sharing=true

## Acknowledgements

This image would not have been possible without the great work from the following projects. Please consider supporting these projects:
- [Docker](https://docker.com)
- [Debian](https://www.debian.org/donations)
- [Wireshark](https://www.wireshark.org/)
- [XPRA](https://xpra.org)