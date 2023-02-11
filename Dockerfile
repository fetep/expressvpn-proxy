FROM debian:stable-slim

ENV CODE="expressvpn_activation_code"
ENV SERVER="smart"
ENV PROTOCOL="lightway_udp"
ENV CIPHER="chacha20"

ARG VERSION=3.42.0.0-1
ARG PLATFORM=amd64

COPY files/ /expressvpn/

RUN mv /expressvpn/contrib.list /etc/apt/sources.list.d \
    && apt-get update && apt-get install -y --no-install-recommends curl expect ca-certificates \
      iproute2 iptables net-tools tinyproxy \
    && curl https://www.expressvpn.works/clients/linux/expressvpn_${VERSION}_${PLATFORM}.deb \
      -o /expressvpn/expressvpn.deb \
    && dpkg -i /expressvpn/expressvpn.deb \
    && rm -rf /expressvpn/*.deb /var/lib/apt/lists/* /var/log/*.log

EXPOSE 3128

ENTRYPOINT ["/expressvpn/init.sh"]
