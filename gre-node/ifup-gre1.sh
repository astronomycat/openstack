ifconfig gre1 down
ip tunnel del gre1
ip tunnel add gre1 mode gre remote 9.186.105.254 local 9.186.104.199
ip addr add 192.168.123.2/24 peer 192.168.123.1/24 dev gre1
ip link set gre1 up multicast on

route add -net 192.168.0.0/16 gw 192.168.123.1

echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter

#iptables -t mangle -A PREROUTING -i gre1 -j TTL --ttl-set 32
iptables -t mangle -A OUTPUT -o gre1 -j TTL --ttl-set 32

pkill -9 smcroute
/root/smcroute-1.99.2/src/smcroute -d -f /root/smcroute-1.99.2/src/smcroute.conf
