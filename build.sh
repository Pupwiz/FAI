sudo fai-make-nfsroot -v -f
cl=DEBIAN,DHCPC,DEMO,FAIBASE,TRIXIE,ONE,SSH_SERVER,STANDARD,NONFREE,FAIME,GRUB_PC,AMD64
fai-mirror  -C /etc/fai -m1 -c$cl /srv/fai/mirror
sudo fai-cd -f -C /etc/fai -g grub.cfg.install-only -m/srv/fai/mirror /srv/fai/faime.iso
