#!/bin/sh /etc/rc.common

apply_wireless_config() {
  local interface=$1
  local main_interface=$2
  local dat_file=$3
  local enable=$(grep -e "ApCliEnable=" "$dat_file")
  
  if [ "$enable" = "ApCliEnable=0" ]; then
    iwpriv "$interface" set ApCliAutoConnect=0
    iwpriv "$interface" set "$enable"
    return
  fi

  local ssid=$(grep -e "ApCliSsid=" "$dat_file")
  local kick=$(grep -e "KickStaRssiLow=" "$dat_file")

  iwpriv "$interface" set "$ssid"
  iwpriv "$interface" set ApCliAutoConnect=3
  iwpriv "$interface" set "$enable"
  iwpriv "$main_interface" set "$kick"
}

start() {
  # 5GHz
  apply_wireless_config "apcli0" "ra0" "/etc/wireless/mt7615/mt7615.1.5G.dat"
  # 2.4GHz
  apply_wireless_config "apclix0" "rax0" "/etc/wireless/mt7615/mt7615.1.2G.dat"
}
