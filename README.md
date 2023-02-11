# ExpressVPN-proxy

Container running a simple HTTP proxy with egress via expressvpn.

Based on [Misioslav/expressvpn](https://github.com/Misioslav/expressvpn).

## Sample Usage

```
docker build -t expressvpn-proxy .

docker run \
  -e "CODE=<expressvpn activation code>" \
  -e "SERVER=smart" \
  --name=expressvpn-proxy \
  --cap-add=NET_ADMIN \
  --privileged \
  --device=/dev/net/tun \
  --publish 3128:3128 \
  expressvpn-proxy

curl -x localhost:3128 ifconfig.me
```
