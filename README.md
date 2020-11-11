Another ad blocker for Linux, system-wide, without `/etc/hosts` modification and using Dnsmasq.

## Dependencies

* Dnsmasq
* curl
* grep (no need for extended regexp)
* awk
* sudo

## Usage

Run `sh adblocker.sh on` and you're done.

Want to have ads back? Simply run `sh adblocker.sh off`.

The script will require your `sudo` password in order to create and remove a Dnsmasq configuration file.

## Advanced configuration

If you know what you are doing, you can edit to variables at the beginning at the script:

* `DNSMASQ_CONF_DIR` is the Dnsmasq directory which will receive the adblocking configuration file
* `DNSMASQ_CONF_FILENAME` is name of the adblocking configuration file

Do not edit `ADBLOCKER_CONF_FILE` as it is based on the two previous variables.

# Information

## Compatibility

This script is compatible with any Linux distro using Dnsmasq.

Tested on Fedora 33 Silverblue. If you tested on another system, please [open an issue](https://github.com/smumu/linux-adblocker/issues/new) so I can add it here.

## Blocking lists

This script uses the [Energized Blu](https://github.com/EnergizedProtection/block) list and [Adaway](https://adaway.org/) list.

Note that I am not affiliated to any of these providers.

## Why Dnsmaq

This script keeps `/etc/hosts` clean so you can edit it without opening a big 200k+ lines file.

And if you have some automatic tools which already edit the hosts file, it won't conflict!

Caution: it does not mean that editing `/etc/hosts` is bad, this script is just another method to block ads on some systems.

## Other adblocking scripts

Those script modify the `/etc/hosts` file (so it works perfectly on any Linux and Mac operating system).

* [MattiSG/adblock](https://github.com/MattiSG/adblock)
* [tuxian0/AdAway-Linux](https://github.com/tuxian0/AdAway-Linux)
* [sedrubal/adaway-linux](https://github.com/sedrubal/adaway-linux) (this repository is archived)

I am not affiliated to any of this project. If you know another system-wide adblocking script, you can [open an issue](https://github.com/smumu/linux-adblocker/issues/new) so I can add it to this list.
