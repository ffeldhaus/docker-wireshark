# Wireshark Web Container Image

Docker image which makes Wireshark available via Web browser using XPRA.

## Usage

Run wireshark container. By default port 14500 will be used. Change docker port mapping to a different port if required (e.g. 5432/14500).

By default it should be sufficient to use the parameter `--cap-add NET_ADMIN` to allow Wireshark to capture traffic, but if Wireshark does not show any interfaces for capturing or shows permission errors, docker must be run with the parameter `--privileged` which grants extended privileges to the container but should be avoided if possible for security reasons.  When using `--net host` to run the container as part of the host network, then published ports will be ignored and you need to make sure that port 14500 is accessible on your host and not blocked via firewall.

By default, the container uses the default self-signed certificate to offer SSL. If you want to specify your own certificate, you can overwrite the default SSL certificate with the docker parameter similar to `--mount type=bind,source="$(pwd)"/ssl-cert.pem,target=/etc/xpra/ssl-cert.pem,readonly` (make sure to put the ssl-cert.pem file in the current folder or modify the source path).

By default, Wireshark can only be accessed using a password. The default password is `wireshark`, but can be changed by setting the environment variable `XPRA_PASSWORD`.

Existing network traces can be uploaded to the container by drag & drop onto the Wireshark window.

It is useful to automatically restart the container on failures using the `--restart unless-stopped` parameter.

If you only want to analyze existing network traces and not collect data from network interfaces, use
```bash
docker run -p 14500:14500 --restart unless-stopped --name wireshark ffeldhaus/wireshark
```

If you wish to analyze traffic from network devices, you should run the container inside your host network with `--net host` and enable network capturing with `--cap-add NET_ADMIN`. When using `--net host` then published ports will be ignored and you need to make sure that port 14500 is accessible on your host and not blocked via firewall:

```bash
docker run --restart unless-stopped --name wireshark --net host --cap-add NET_ADMIN ffeldhaus/wireshark
```

If that didn't work, it may be necessary to start the container as priviliged

```bash
docker run --restart unless-stopped --name wireshark --net host --privileged ffeldhaus/wireshark
```

To allow analyzing traffic of network devices, change the password to connect and provide a custom SSL certificate, use

```bash
docker run --restart unless-stopped --name wireshark --net host --cap-add NET_ADMIN -e XPRA_PASSWORD=mypassword --mount type=bind,source="$(pwd)"/ssl-cert.pem,target=/etc/xpra/ssl-cert.pem,readonly ffeldhaus/wireshark
```

Access Wireshark via the browser using the IP/Hostname of your docker host, disable the XPRA floating menu with `floating_menu=false` and provide the password (change `password=wireshark` if you provided a different password via `XPRA_PASSWORD`) using e.g.

    https://<yourhostname>:14500/?floating_menu=false&password=wireshark

If you want to allow to share your session, use

    https://<yourhostname>:14500/?floating_menu=false&password=wireshark&sharing=true

## Acknowledgements

This image would not have been possible without the great work from the following projects. Please consider supporting these projects:
- [Wireshark](https://www.wireshark.org/)
- [XPRA](https://xpra.org)