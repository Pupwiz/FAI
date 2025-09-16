#!/bin/bash

##Sonarr build custom deb package
srv=/srv/config/pkgs/FAIME
DIR=$(pwd)
rm $srv/sonarr*.deb
mkdir -p $DIR/sonarr_amd64/opt
wget --content-disposition "https://services.sonarr.tv/v1/download/develop/latest?version=4&os=linux&arch=x64"
sonarr=$(find ./Sonarr*  -name '*.tar.gz'|grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
tar xfz Sonarr.develop.*.linux-x64.tar.gz -C $DIR/sonarr_amd64/opt
##sonarr=$(awk -F= '/ReleaseVersion=/{print $2; exit}' $DIR/sonarr_amd64/opt/Sonarr/release_info)
rm Sonarr.develop.*.linux-x64.tar.gz 
cp $DIR/templates/sonarr/. $DIR/sonarr_amd64/ -r
sed -i.bak "/^[[:space:]]*Version:/ s/:.*/: ${sonarr}/" $DIR/sonarr_amd64/DEBIAN/control
chmod 775 $DIR/sonarr_amd64/DEBIAN
chown -R media: $DIR/sonarr_amd64/home $DIR/sonarr_amd64/opt
dpkg-deb -b sonarr_amd64/ sonarr_${sonarr}-amd64.deb
mv sonarr_${sonarr}-amd64.deb $srv 
rm sonarr_amd64/ -r

##Radarr custom deb package 
srv=/srv/config/pkgs/FAIME
DIR=$(pwd)
rm $srv/radarr*.deb
mkdir -p $DIR/radarr_amd64/opt
wget --content-disposition 'https://radarr.servarr.com/v1/update/develop/updatefile?os=linux&runtime=netcore&arch=x64'
tar xfz Radarr.*.*.linux-core-x64.tar.gz -C $DIR/radarr_amd64/opt
VER=$(find ./Radarr*  -name '*.tar.gz'|grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
rm Radarr.*.*.linux-core-x64.tar.gz
cp $DIR/templates/radarr/. $DIR/radarr_amd64/ -r
sed -i.bak "/^[[:space:]]*Version:/ s/:.*/: $VER/" $DIR/radarr_amd64/DEBIAN/control
chown -R media: $DIR/radarr_amd64/home $DIR/radarr_amd64/opt
chmod 775 $DIR/radarr_amd64/DEBIAN
dpkg-deb -b radarr_amd64/ radarr_$VER-amd64.deb
mv radarr_$VER-amd64.deb $srv
rm $DIR/radarr_amd64/ -r

## Prowlarr custom deb package 

rm $srv/prowlarr*.deb
mkdir -p $DIR/prowlarr_amd64/opt
wget --content-disposition "https://prowlarr.servarr.com/v1/update/develop/updatefile?os=linux&runtime=netcore&arch=x64"
tar xfz Prowlarr.*.*.linux-core-x64.tar.gz -C $DIR/prowlarr_amd64/opt
VER=$(find ./Prowlarr*  -name '*.tar.gz'|grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
rm Prowlarr.*.*.linux-core-x64.tar.gz
cp $DIR/templates/prowlarr/. $DIR/prowlarr_amd64/ -r
sed -i.bak "/^[[:space:]]*Version:/ s/:.*/: $VER/" $DIR/prowlarr_amd64/DEBIAN/control
chown -R media: $DIR/prowlarr_amd64/home $DIR/prowlarr_amd64/opt
chmod 775 $DIR/prowlarr_amd64/DEBIAN
dpkg-deb -b prowlarr_amd64/ prowlarr_$VER-amd64.deb
mv prowlarr_$VER-amd64.deb $srv
rm $DIR/prowlarr_amd64/ -r

##adding Unpackerr
DIR=$(pwd)
rm $srv/unpackerr*.deb
type=amd64.deb
unpackerrlatest=$(curl -s https://api.github.com/repos/Unpackerr/unpackerr/releases/latest | jq -r ".assets[] | select(.name | test(\"${type}\")) | .browser_download_url")
wget $unpackerrlatest -P $srv/

## Adding Emby-Server 

rm $srv/emby*.deb
function github_latest_version() {
    repo=$1
    curl -fsSLI -o /dev/null -w %{url_effective} https://github.com/${repo}/releases/latest | grep -o '[^/]*$'
}
os_arch=$(dpkg --print-architecture)
current=$(github_latest_version MediaBrowser/Emby.Releases)
wget -P $srv/  https://github.com/MediaBrowser/Emby.Releases/releases/download/${current}/emby-server-deb_${current}_${os_arch}.deb 

##Building box tools for configs and database templates 

VER=1.06
srv=/srv/config/pkgs/FAIME
DIR=$(pwd)
rm $srv/boxtools*.deb
mkdir -p $DIR/boxtools_amd64/opt
cd $DIR/boxtools_amd64/opt
git clone https://github.com/cockpit-project/cockpit-files.git
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git mp4auto
git clone https://github.com/ThePhaseless/Byparr.git Byparr
cd $DIR
cp $DIR/templates/boxtools/* $DIR/boxtools_amd64 -rf
chmod 775 $DIR/boxtools_amd64/DEBIAN
dpkg-deb -b boxtools_amd64/ boxtools_$VER-amd64.deb
mv boxtools_$VER-amd64.deb $srv
##Remove html folder for next build or it will cause errors
rm $DIR/templates/boxtools/var/www/html -rf
rm $DIR/boxtools_amd64/ -rf
exit 0
