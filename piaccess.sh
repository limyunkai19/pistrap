#!/bin/bash

# verify sudo
if [ $(id -u) -ne 0 ]; then
  echo "Script must be run as root. Try sudo ./piaccess.sh"
  exit 1
fi

# read config file
CFG_FILE=${BASH_SOURCE%/*}/pistrap.conf
eval $(sed -r '/[^=]+=[^=]+/!d;s/\s+=\s+/=/g;s/\r//g' "$CFG_FILE")

# check if disable
if [ "$1" = "--disable" ]; then
    # user confirmation
    echo "Disable Raspberry Pi Access Point"
    echo -ne "static ip:\t" && ( [ "$static_ip" = true ] && echo "yes" || echo "no (using DHCP)" )
    if [ "$static_ip" = true ]; then
        echo "    interface $static_interface"
        echo "    static ip_address=$static_ip_address"
        echo "    static routers=$static_routers"
        echo "    static domain_name_servers=$static_dns"
    fi
    echo
    read -p "Revert by using the above setting, do you want to continue [Y/n]? " -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi

    # stop related service
    systemctl stop hostapd
    systemctl stop dnsmasq

    # revert ip forwarding and routing for security
    sed -i '/net.ipv4.ip_forward=/c\net.ipv4.ip_forward=0' /etc/sysctl.conf
    sed -i "/iptables -t nat -A POSTROUTING/d" /etc/rc.local

    # revert ip and dhcp setting using pistrap.conf
    cp raspbian_conf/dhcpcd.conf /etc/dhcpcd.conf
    if [ "$static_ip" = true ]; then
        echo "Configuring static ip address"
        metric=100
        for int in $static_interface; do
            echo "interface $int" >> /etc/dhcpcd.conf
            echo "metric $metric" >> /etc/dhcpcd.conf
            echo "static ip_address=$static_ip_address" >> /etc/dhcpcd.conf
            echo "static routers=$static_routers" >> /etc/dhcpcd.conf
            echo "static domain_name_servers=$static_dns" >> /etc/dhcpcd.conf
            echo "" >> /etc/dhcpcd.conf

            metric=$((metric + 100))
        done
    fi

    exit 0
fi

# user confirmation
echo "Enable Raspberry Pi Access Point"
echo -e "ssid:\t$ssid"
echo -e "psk:\t$psk"
echo ""
echo -e "internet_interface:\t\t\t$internet_interface"
echo -ne "static_ip_on_internet_interface:\t" && ( [ "$static_ip_on_internet_interface" = true ] && echo "yes" || echo "no" )
echo ""
echo -e "ap_interface:\t\t$ap_interface"
echo -e "interface_ip:\t\t$interface_ip"
echo -e "number_of_client:\t$number_of_client"
echo -e "starting_ip:\t\t$starting_ip"
echo
read -p "Using the above setting, do you want to continue [Y/n]? " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo "apt-get update"
apt-get update &>/dev/null

# install prerequisite
if ! (dpkg -l | grep -q dnsmasq) || ! (dpkg -l | grep -q hostapd); then
    echo "Installing dependency: dnsmasq hostapd"
    apt-get install -y dnsmasq hostapd &>/dev/null
fi

# configure wlan interface IP
cp raspbian_conf/dhcpcd.conf /etc/dhcpcd.conf
echo "interface $ap_interface" >> /etc/dhcpcd.conf
echo "    static ip_address=$interface_ip/24" >> /etc/dhcpcd.conf
echo "    nohook wpa_supplicant" >> /etc/dhcpcd.conf
echo "    denyinterfaces $ap_interface" >> /etc/dhcpcd.conf

# configure dnsmasq DHCP server
cp raspbian_conf/dnsmasq.conf /etc/dnsmasq.conf
echo "interface=$ap_interface" >> /etc/dnsmasq.conf
base_ip=`echo $interface_ip | cut -d"." -f1-3`
ending_ip=$base_ip.$((starting_ip+number_of_client))
starting_ip=$base_ip.$starting_ip
echo "dhcp-range=$starting_ip,$ending_ip,255.255.255.0,24h" >> /etc/dnsmasq.conf

# configure hostapd
cp raspbian_conf/hostapd /etc/default/hostapd
echo "
interface=$ap_interface
driver=nl80211
ssid=$ssid
hw_mode=g
channel=3
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$psk
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
" > /etc/hostapd/hostapd.conf

# restart all service after configuration
echo "Configuration done, restarting dhcp service and hostapd service"
service dhcpcd restart &>/dev/null
systemctl restart hostapd
systemctl restart dnsmasq
systemctl daemon-reload

# setup IP packet forwarding and routing
sed -i '/net.ipv4.ip_forward=/c\net.ipv4.ip_forward=1' /etc/sysctl.conf
# iptables -t nat -A POSTROUTING -o $internet_interface -j MASQUERADE
# add rule above in rc.local
if grep -q 'iptables \-t nat \-A POSTROUTING' /etc/rc.local; then
    sed -i "/iptables -t nat -A POSTROUTING/c\iptables -t nat -A POSTROUTING -o $internet_interface -j MASQUERADE" /etc/rc.local
else
    sed -i "/^exit 0$/c\iptables -t nat -A POSTROUTING -o $internet_interface -j MASQUERADE\n\nexit 0" /etc/rc.local
fi

# done configuration, reboot
echo "Configuration done, most of the setting need reboot to be effective"
read -p "Reboot now [Y/n]? " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
fi
