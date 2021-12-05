#!/bin/bash
sudo apt update && sudo apt upgrade -y

sudo snap install nextcloud

echo Choose a username for nextcloud:
read username

echo Choose a password for nextcloud:
read password

sudo nextcloud.manual-install $username $password 
echo Nextcloud has been installed on localhost

echo Please choose a domain for server:
read domain

sudo nextcloud.occ config:system:set trusted_domains 1 --value=$domain

echo Domain name set to $domain

sudo snap connect nextcloud:removable-media
sudo ufw allow 80,443/tcp

echo Would you like to enable https (y/n)?
read ssl

if [ $ssl = y ]
then
    echo Does your nextcloud instance use a bare IP address (y/n)?
    read ip 

    if [ $ip = y]
    then
        sudo nextcloud.enable-https self-signed
        echo Nextcloud has been installed. Go to https://$domain to access GUI
    fi

    if [ $ip = n ]
    then
        sudo nextcloud.enable-https lets-encrypt 
        echo Nextcloud has been installed. Go to https://$domain to access GUI
    fi
fi

if [ $ssl = no ] 
then 
    echo Nextcloud has been installed. Go to http://$domain to access GUI
fi
