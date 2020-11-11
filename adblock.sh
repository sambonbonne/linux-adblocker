#!/usr/bin/env sh

##
# This script blocks ads sytem-wide on Linux
#
# Dependencies:
#   - dnsmasq
#   - curl
#   - grep (no need for extended regexp)
#   - awk
#   - sudo
#
# Usage: sh adblocker.sh <on|off>
#
# Warning: this script put configuration in /etc/dnsmasq.d/ and won't work if this directory does not exist
##

set -e

DNSMASQ_CONF_DIR="/etc/dnsmasq.d"
DNSMASQ_CONF_FILENAME="adblocking.conf"

test -d "${DNSMASQ_CONF_DIR}" || { echo "Missing Dnsmasq configuration directory: ${DNSMASQ_CONF_DIR}"; exit 1; }

ADBLOCKER_CONF_FILE="${DNSMASQ_CONF_DIR}/${DNSMASQ_CONF_FILENAME}"

##
# Get hosts files on public list and add custom hosts
##
get_blocked_hosts() {
  curl -L "https://adaway.org/hosts.txt"
  curl -L "https://block.energized.pro/blu/formats/hosts-ipv6.txt"
  echo "127.0.0.1 s.ytimg.com" # YT ads
}

##
# Remove IP address from hosts list
##
extract_hosts_domains() {
  grep -v '^#' \
    | cut -d ' ' -f 2- \
    | tr -d '[:blank:]'
}

##
# Remove local hosts from lists
##
filter_hosts() {
  grep -v '\(^\|.\)localhost$\|\.\?local$\|^ip6-\|^\(0.0.0.0\|127.0.0.1\|::1\|broadcasthost\)$'
}

##
# Remove whitespaces and duplicates from domains list
##
clean_hosts_list() {
  sed -e '/^[[:space:]]*$/d' \
    | sort -u
}

##
# Format domains for Dnsmask
# @TODO: change AWK for a POSIX command
##
format_domains() {
  awk '{print "address=/" $0 "/"}'
}


##
# Run all steps to block ads
##
setup_adblocking() {
  TMP_ADBLOCKER_CONF_FILE="$(mktemp)"

  get_blocked_hosts \
    | extract_hosts_domains \
    | filter_hosts \
    | clean_hosts_list \
    | format_domains \
    > "${TMP_ADBLOCKER_CONF_FILE}"

  echo "Hosts file ready, moving to ${ADBLOCKER_CONF_FILE} ($(wc -l "${TMP_ADBLOCKER_CONF_FILE}" | cut -d ' ' -f 1) entries)"
  sudo mv "${TMP_ADBLOCKER_CONF_FILE}" "${ADBLOCKER_CONF_FILE}"
}

if [ "${1}" = "on" -o \( "${1}" = "" -a ! -f "${ADBLOCKER_CONF_FILE}" \) ]; then
  echo "Enabling adblocker"
  setup_adblocking
elif [ "${1}" = "off" -o \( "${1}" = "" -a -f "${ADBLOCKER_CONF_FILE}" \) ]; then
  echo "Disabling adblocker"
  sudo rm "${ADBLOCKER_CONF_FILE}"
else
  echo "Unknown argument ${1}, try with on or off"
  exit 2
fi
