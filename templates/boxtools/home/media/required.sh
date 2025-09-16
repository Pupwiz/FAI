#!/bin/bash
sudo usermod -a -G media emby
sudo usermod -a -G emby media
DEBIAN_FRONTEND=noninteractive apt-get -qq remove debian-faq debian-faq-de debian-faq-fr debian-faq-it debian-faq-zh-cn  doc-debian foomatic-filters hplip iamerican ibritish ispell vim-common vim-tiny reportbug laptop-detect zutty
sudo apt autoremove -qq -y
cd /opt/cockpit-files
make
sudo make install 
# live enable tailscale to my account
# tailscale up -authkey #### -ssh
(crontab -u root -l ; echo "@reboot /home/media/surfsafe/checkstatus.sh") | crontab -u root -
(crontab -u root -l ; echo "0 */4 * * * /home/media/surfsafe/checkstatus.sh") | crontab -u root -
cd /home/media 
sudo systemctl stop nginx 
sudo mv /home/media/nginx.conf /etc/nginx 
sudo mv /home/media/sites-available/default /etc/nginx/sites-available/ 
sudo rm /home/media/sites-available -r
sudo systemctl start nginx
sudo systemctl enable byparr.service
sudo systemctl start byparr.service
xhost si:localuser:root
rm -- "$0"
exit 0
