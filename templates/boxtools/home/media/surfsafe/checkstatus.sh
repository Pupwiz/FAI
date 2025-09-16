#!/usr/bin/sudo bash

if [ "$(nmcli connection show --active wgclient | wc -l)" -gt 0 ]; then
    echo "connected"
else
    echo "not connected"
sudo bash /home/media/surfsafe/wireguard_exe_up /home/media/surfsafe/us-nyc.conf
fi
