echo "server ip: "
read VPN_SERVER_IP

mkdir -p /var/run/xl2tpd
touch /var/run/xl2tpd/l2tp-control

echo "restarting strongswan and xl2tpd"
service strongswan restart
service xl2tpd restart
echo

echo "starting ipsec"
sleep 1
ipsec up myvpn
echo

echo "connecting..."
echo "c myvpn" > /var/run/xl2tpd/l2tp-control
echo

gateway=$(ip route | grep "default via" | awk '{ print $3 }')
echo "adding gateway"
command="route add $VPN_SERVER_IP gw $gateway"
eval $command
echo

sleep 1
echo "adding ppp0"
ip route add default dev ppp0
