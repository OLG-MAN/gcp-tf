#!/bin/bash

sudo su<< HERE
### Install Apache
apt update && apt install apache2 -y

### Copy index.html 
gsutil cp gs://startup-bucket101/index.html .
mv index.html /var/www/html

### Add metadata content
echo '<h1>' >> /var/www/html/index.html
echo '<p>Metadata</p>' >> /var/www/html/index.html
curl "http://metadata.google.internal/computeMetadata/v1/instance/name" -H "Metadata-Flavor: Google" >> /var/www/html/index.html
echo '<br>' >> /var/www/html/index.html
curl "http://metadata.google.internal/computeMetadata/v1/instance/hostname" -H "Metadata-Flavor: Google" >> /var/www/html/index.html
echo '<br>' >> /var/www/html/index.html
curl 2ip.me >> /var/www/html/index.html
echo '</h1>' >> /var/www/html/index.html
echo '</body>' >> /var/www/html/index.html
echo '</html>' >> /var/www/html/index.html
systemctl restart apache2

### Install MySQL
apt install mariadb-server mariadb-client -y
HERE