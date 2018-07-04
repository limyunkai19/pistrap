#!/bin/bash

# verify sudo
if [ $(id -u) -ne 0 ]; then
  echo "Script must be run as root. Try sudo ./pistrap.sh"
  exit 1
fi

# read config file
CFG_FILE=${BASH_SOURCE%/*}/pistrap.conf
eval $(sed -r '/[^=]+=[^=]+/!d;s/\s+=\s+/=/g;s/\r//g' "$CFG_FILE")

# verifying config file
# verify locale
if ! grep -q "^$locale " /usr/share/i18n/SUPPORTED; then
    echo "Invalid locale: $locale" && exit 1
fi
# verify timezone
if [ ! -f "/usr/share/zoneinfo/$timezone" ]; then
    echo "Invalid timezone: $timezone" && exit 1
fi
# user confirmation
echo -e "hostname:\t$hostname"
echo -ne "enable ssh:\t" && ( [ "$enable_ssh" = true ] && echo "yes" || echo "no" )
echo -e "locale:\t\t$locale"
echo -e "timezone:\t$timezone"
echo -ne "install zsh:\t" && ( [ "$install_zsh" = true ] && echo "yes" || echo "no" )
echo -ne "static ip:\t" && ( [ "$static_ip" = true ] && echo "yes" || echo "no" )
if [ "$static_ip" = true ]; then
    echo "    interface $static_interface"
    echo "    static ip_address=$static_ip_address"
    echo "    static routers=$static_routers"
    echo "    static domain_name_servers=$static_dns"
fi
echo
read -p "Using the above setting, do you want to continue [Y/n]? " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# configure locale, timezone and ssh
echo "Configuring locale, timezone and ssh"
raspi-config nonint do_change_locale $locale &>/dev/null
raspi-config nonint do_change_timezone $timezone &>/dev/null

# ssh
if [ "$enable_ssh" = true ]; then
    raspi-config nonint do_ssh 0 &>/dev/null
else
    raspi-config nonint do_ssh 1 &>/dev/null
fi

# install zsh
if [ "$install_zsh" = true ]; then
    if [ ! -d $(getent passwd $SUDO_USER | cut -d: -f6)/.oh-my-zsh ]; then
        echo "Zsh installed, not installing"
    else
        echo "Installing zsh, this may take some time"
        apt-get update &>/dev/null
        apt-get install -y zsh git &>/dev/null
        chsh -s $(which zsh) $SUDO_USER

        echo "Installing oh-my-zsh"
        su - $SUDO_USER -c '0>/dev/null sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"' &>/dev/null
    fi
fi

## need to reboot
# static ip
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

# configure host name
echo "Configuring hostname"
raspi-config nonint do_hostname $hostname

echo "Configuration done, most of the setting need reboot to be effective"
read -p "Reboot now [Y/n]? " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
fi
