# pistrap
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/limyunkai19/minimal-mistakes-jekyll/blob/master/LICENSE)


Raspberry Pi bootstrapping script. A quick way to setup your Pi.

see limyunkai.com for more a more detail installation workflow and usage.

## Usage
Change the `pistrap.conf` file according to your desire configuration.

Use the command `sudo bash pistrap.sh` to apply your configuration.

## Configuration

Setting    | Explanation | Acceptable Value | Default Value
-----------|-------------|------------------|--------------
hostname   | set the hostname of your Raspberry Pi, you can access your Raspberry Pi at `hostname.local` | lower case letter from `a` to `z`, digit from `0` to `9` and hyphen `-`. You cannot start and end the hostname with hyphen `-`. Blank space is **not** allowed.| `raspberrypi`
enable_ssh | enable/disable ssh on your Raspberry Pi | `true` (enable ssh) or `false` (disable ssh) | `true`
locale     | set the locale of your Raspberry Pi | if you are not sure for this one, it is recommended to leave it as the default | `en_US.UTF-8`
timezone   | set the timezone of your Raspberry Pi | find your timezone at [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) or use `pistrap/find_timezone.sh`. Some timezone example are `Asia/Kuala_Lumpur`, `America/New_York` | `Etc/UTC`
install_zsh| install my favorite shell, _zsh_ with _oh-my-zsh_ and set _zsh_ as default shell | `true` (install _zsh_) or `false` don't install _zsh_. _zsh_ are great but installing it may take some time and internet connection. | `false`

## To Do
- [ ] Configure keyboard for GUI user
