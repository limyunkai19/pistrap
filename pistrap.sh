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
echo -ne "install zsh:\t" && ( [ "$enable_ssh" = true ] && echo "yes" || echo "no" )
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

## ssh
if [ "$enable_ssh" = true ]; then
    raspi-config nonint do_ssh 0 &>/dev/null
else
    raspi-config nonint do_ssh 1 &>/dev/null
fi

# install zsh
if [ "$install_zsh" = true ]; then
    echo "Installing zsh, this may take some time"
    apt-get update &>/dev/null
    apt-get install -y zsh git &>/dev/null
    chsh -s $(which zsh) $SUDO_USER

    echo "Installing oh-my-zsh"
    su - $SUDO_USER -c '0>/dev/null sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"' &>/dev/null
fi


## need to reboot
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


###### to do ######
# ip stuff

# configure keyboard
# for gui user, ssh can ignore
