#!/usr/bin/env bash

mv /expressvpn/tinyproxy.conf /etc/tinyproxy/
service tinyproxy start

# expressvpn needs to poke resolv.conf for some reason
cp -p /etc/resolv.conf /etc/resolv.conf.keep
umount /etc/resolv.conf
mv /etc/resolv.conf.keep /etc/resolv.conf

service expressvpn start
/expressvpn/activate.expect

# block non-vpn web traffic.
# TODO: block ALL non-vpn traffic, except expressvpn protocol looking traffic?
iptables -A OUTPUT -p tcp --dport 80 -o eth0 -j REJECT
iptables -A OUTPUT -p tcp --dport 443 -o eth0 -j REJECT

expressvpn preferences set auto_connect true
expressvpn preferences set block_trackers true
expressvpn preferences set desktop_notifications false
expressvpn preferences set disable_ipv6 true
expressvpn preferences set lightway_cipher "$CIPHER"
expressvpn preferences set preferred_protocol "$PROTOCOL"
expressvpn preferences set send_diagnostics false

expressvpn connect "$SERVER"

tmpd=$(mktemp -d)
trap "rm -rf '$tmpd'" EXIT

# show changes in `expressvpn status`
cd $tmpd
touch old
while :; do
  expressvpn status >new 2>&1

  if ! cmp -s old new; then
    cat new | sed -e "s,^,$(date): ,"
    cp new old
  fi

  sleep 5
done
