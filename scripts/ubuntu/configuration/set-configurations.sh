#!/bin/bash
set -xe

# Setting locale to en us utf-8
export LANGUAGE="en_US.UTF-8"
echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale


# Updating configuration files
sed -i "s/UNSAFE_DEFAULT/${SECRET_TEXT}/" /etc/graphite/local_settings.py
sed -i 's/#SECRET_KEY/SECRET_KEY/' /etc/graphite/local_settings.py
sed -i 's/#TIME_ZONE/TIME_ZONE/' /etc/graphite/local_settings.py
sed -i "s/Los_Angeles/${TIMEZONE}/" /etc/graphite/local_settings.py
sed -i "s/\/var\/lib\/graphite\/graphite.db/${DATABASE_NAME}/g" /etc/graphite/local_settings.py
sed -i 's/django.db.backends.sqlite3/django.db.backends.mysql/g' /etc/graphite/local_settings.py
sed -i "s/'USER': ''/'USER': '${DATABASE_USER}'/g" /etc/graphite/local_settings.py
sed -i "s/'PASSWORD': ''/'PASSWORD': '${DATABASE_PASSWORD}'/g" /etc/graphite/local_settings.py
sed -i "s/'HOST': ''/'HOST': '127.0.0.1'/g" /etc/graphite/local_settings.py
sed -i "s/'PORT': ''/'PORT': '3306',\n    'STORAGE_ENGINE': 'INNODB'/g" /etc/graphite/local_settings.py

sudo graphite-manage syncdb --noinput || true
sudo graphite-manage syncdb --noinput

sed -i 's/CARBON_CACHE_ENABLED=false/CARBON_CACHE_ENABLED=true/g' /etc/default/graphite-carbon
sudo systemctl start carbon-cache

# Enabling default site with apache2
a2dissite 000-default
sudo cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available

# Replacing 80 host port with defined value
sudo sed -i "s/*:80/*:${GRAPHITE_PORT}/g" /etc/apache2/sites-available/apache2-graphite.conf

# Enabling apache to listen to defined port
sudo sed -i "s/Listen 80/Listen 80\nListen ${GRAPHITE_PORT}/g" /etc/apache2/ports.conf

# Enabling apache2-graphite site on apache2 and restarting apache 2 service
a2ensite apache2-graphite 
systemctl restart apache2