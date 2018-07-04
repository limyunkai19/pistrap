# pistrap
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/limyunkai19/minimal-mistakes-jekyll/blob/master/LICENSE)


Raspberry Pi bootstrapping script. A quick way to setup your Pi.

see limyunkai.com for more a more detail installation workflow and usage.

## Usage
Change the `pistrap.conf` file according to your desire configuration.

Use the command `sudo bash ./pistrap.sh` to apply your configuration.

## Configuration

Setting    | Explanation | Acceptable Value | Default Value
-----------|-------------|------------------|--------------
hostname   | set the hostname of your Raspberry Pi, you can access your Raspberry Pi at `hostname.local` | lower case letter from `a` to `z`, digit from `0` to `9` and hyphen `-`. You cannot start and end the hostname with hyphen `-`. Blank space is **not** allowed.| `raspberrypi`
enable_ssh | enable/disable ssh on your Raspberry Pi | `true` (enable ssh) or `false` (disable ssh) | `true`
locale     | set the locale of your Raspberry Pi | if you are not sure for this one, it is recommended to leave it as the default | `en_US.UTF-8`
timezone   | set the timezone of your Raspberry Pi | find your timezone at [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) or use `pistrap/find_timezone.sh`. Some timezone example are `Asia/Kuala_Lumpur`, `America/New_York` | `Etc/UTC`
install_zsh| install my favorite shell, _zsh_ with _oh-my-zsh_ and set _zsh_ as default shell | `true` (install _zsh_) or `false` don't install _zsh_. _zsh_ are great but installing it may take some time and internet connection. | `false`
static_ip | setup your Pi using static IP address | `true` (use static IP) or `false` (use default DHCP) | `false`
static_interface | the interface to enable static IP on | the interface name with double quote and separated with space order from highest priority to lowest. For example, `"eth0 wlan0"` enable the static IP settings to be apply on `eth0` (the default ethernet interface) and `wlan0` (the wireless interface) with ethernet has a higher priority with both are available | `"eth0 wlan0"`
static_ip_address | the static IP address to configure | the format is `ipv4/subnet`, for example, `192.168.1.30/24`. If you are not familiar with IP, *usually* your home router will have a subnet mask of `/24` and the first 3 octets (number) are usually `192.168.0.x`, `192.168.1.x` or `192.168.2.x`. You need to figure out which first 3 number of your network using a computer in the same network. Use `ipconfig` in Windows *cmd* or `ifconfig` in macOS, Linux *terminal*. Then, set the `x` be a number between `20` and `250` | `0.0.0.0/24`
static_routers | the default gateway of the network | the IP address of the default gateway, for example, `192.168.1.1`. You can figure out the default gateway using a computer in the same network. Use `ipconfig` in Windows *cmd*, `route -n get default` in macOS *terminal*, <code>ip route &#124; grep default</code> in Linux *terminal* to figure out your gateway IP, it *usually* ends with `.1` or `.254` | `0.0.0.0`
static_dns | the DNS server for you Raspberry PI | the DNS IP address, for example, `192.168.1.1`. *usually* the DNS server will be same as the gateway, if gateway does not work, try use Google DNS `8.8.8.8` | `0.0.0.0`

## To Do
- [ ] Configure keyboard for GUI user
