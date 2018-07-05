# pistrap
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/limyunkai19/minimal-mistakes-jekyll/blob/master/LICENSE)


Raspberry Pi bootstrapping script. A quick way to setup your Pi.

## Usage
Change the `pistrap.conf` file according to your desire configuration.

Use the command `sudo ./pistrap.sh` to apply your configuration.

## Configuration

Setting    | Explanation | Acceptable Value | Default Value
-----------|-------------|------------------|--------------
hostname   | set the hostname of your Raspberry Pi, you can access your Raspberry Pi at `hostname.local` | lower case letter from `a` to `z`, digit from `0` to `9` and hyphen `-`. You cannot start and end the hostname with hyphen `-`. Blank space is **not** allowed.| `raspberrypi`
enable_ssh | enable/disable ssh on your Raspberry Pi | `true` (enable ssh) or `false` (disable ssh) | `true`
locale     | set the locale of your Raspberry Pi | if you are not sure for this one, it is recommended to leave it as the default | `en_US.UTF-8`
timezone   | set the timezone of your Raspberry Pi | find your timezone at [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) or use `pistrap/find_timezone.sh`. Some timezone example are `Asia/Kuala_Lumpur`, `America/New_York` | `Etc/UTC`
install_zsh| install my favorite shell, _zsh_ with _oh-my-zsh_ and set _zsh_ as default shell | `true` (install _zsh_) or `false` don't install _zsh_. _zsh_ are great but installing it may take some time and internet connection. | `false`
install_rsub | install *rsub* which support remote file editing using Sublime Text | `true` (install *rsub*) or `false` (don't install *rsub*) | `false`
static_ip | setup your Pi using static IP address | `true` (use static IP) or `false` (use default DHCP) | `false`
static_interface | the interface to enable static IP on | the interface name with double quote and separated with space order from highest priority to lowest. For example, `"eth0 wlan0"` enable the static IP settings to be apply on `eth0` (the default ethernet interface) and `wlan0` (the wireless interface) with ethernet has a higher priority with both are available | `"eth0 wlan0"`
static_ip_address | the static IP address to configure | the format is `ipv4/subnet`, for example, `192.168.1.30/24`. If you are not familiar with IP, *usually* your home router will have a subnet mask of `/24` and the first 3 octets (number) are usually `192.168.0.x`, `192.168.1.x` or `192.168.2.x`. You need to figure out which first 3 number of your network using a computer in the same network. Use `ipconfig` in Windows *cmd* or `ifconfig` in macOS, Linux *terminal*. Then, set the `x` be a number between `20` and `250` | `0.0.0.0/24`
static_routers | the default gateway of the network | the IP address of the default gateway, for example, `192.168.1.1`. You can figure out the default gateway using a computer in the same network. Use `ipconfig` in Windows *cmd*, `route -n get default` in macOS *terminal*, <code>ip route &#124; grep default</code> in Linux *terminal* to figure out your gateway IP, it *usually* ends with `.1` or `.254` | `0.0.0.0`
static_dns | the DNS server for you Raspberry PI | the DNS IP address, for example, `192.168.1.1`. *usually* the DNS server will be same as the gateway, if gateway does not work, try use Google DNS `8.8.8.8` | `0.0.0.0`

<br>
<dl>
    <strong>Pi Access Point:</strong>
    <dd>
        configure your Raspberry Pi as a access point (WiFi Hotspot) that is able to redirect Internet traffic to and from WiFi interface and Ethernet interface. Configure the following parameters and use the command <code>sudo ./piaccess.sh</code> to configure your Pi as a access point and use <code>sudo ./piaccess.sh --disable</code> to disable it
    </dd>
</dl>

Setting    | Explanation | Acceptable Value | Default Value
-----------|-------------|------------------|--------------
ssid | set the SSID of your access point | maximum of 32 character | `raspberrypi`
psk | set the password for your access point | 8 to 63 character | `secretpassword`
internet_interface | the interface which your Raspberry Pi could obtain Internet access | a Linux network interface name, for example `eth0`, `wlan1`. Leave as default if you are not sure | `eth0`
static_ip_on_<br>internet_interface | use static IP define by `static_ip_address`, `static_routers` and `static_dns` option on the Internet interface | `true` (use static IP on Internet interface) or `false` (use default DHCP on Internet interface) | `false`
ap_interface | the wireless interface which your Raspberry Pi will act as a access point | a Linux network interface name, for example `eth0`, `wlan1`. Leave as default if you are not sure | `wlan0`
interface_ip | the IP address for the access point interface, will act as default gateway for client | the format is `x.x.x.x`, for example, `192.168.20.1`. If you are not familiar with IP, leave it as default. <br>**Note**: the subnet mask will be `/24` | `192.168.20.1`
starting_ip | the starting IP address for the DHCP service to assign to client | `2` to `250`. If you are not familiar with IP, leave it as default. | `10`
number_of_client | the number of device that is able to connect to your access point | any number as long as `starting_ip + number_of_client < 255` | `30`


## To Do
- [ ] Configure keyboard for GUI user
- [ ] Research how to setup file and print server
