### LAMP Stack
base install: https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mariadb-php-lamp-stack-on-debian-10 \
some dependencies added
#### apache
`sudo apt update && sudo apt install apache2`\
`sudo apt install software-properties-common`
#### requeriments
- `sudo apt install php libapache2-mod-php php-mysql`
- `sudo apt install php-common php-bcmath php-fpm php-xml php-zip php-curl php-mbstring php-gd`
- `sudo apt install php-tidy` this also installs libtidy5deb1 php7.3-tidy
- `sudo apt install php-mbstring php-mysql php-json php-pdo php-curl php-bcmath php-zip`
#### composer
- `sudo apt install curl php-cli php-mbstring git unzip`
- `cd ~ && curl -sS https://getcomposer.org/installer -o composer-setup.php`

To install composer as a system-wide command named `composer`, under `/usr/local/bin`:
- `sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer`\
Output:
```
All settings correct for using Composer
Downloading...
Composer (version 1.9.1) successfully installed to: /usr/local/bin/composer
Use it: php /usr/local/bin/composer
$ composer -V
Composer version 1.9.1 2019-11-01 17:20:17

```
#### mariadb
- `sudo apt install mariadb-server`
- `sudo mysql_secure_installation`


#### Apache Virtual Hosts
By default, Apache(and nginx) serves its content from a directory located at `/var/www/html`, using the configuration contained in `/etc/apache2/sites-available/000-default.conf`\
Virtual hosts enable us to keep multiple websites hosted on a single Apache server.

To try new websites, may be necessary to disable the default website that comes installed with Apache.\
This is required if you’re not using a custom domain name, because in this case Apache’s default configuration would overwrite your Virtual Host.\
To disable Apache’s default website, type:
- `sudo a2dissite 000-default`
Alternatively you can edit hosts file `/etc/hosts/`
```bash
127.0.1.1       server1.com www.server1.com
```
Then access the newly created virtual host with `http://server1.com`

#### Adminer
From http://www.ubuntuboss.com/how-to-install-adminer-on-ubuntu-18-04/ 
- `sudo mkdir /usr/share/adminer`
- `sudo wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php`
Create symbolic link between `latest.php` and `adminer.php` to autoupdate the latter when the former is changed
- `sudo ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php`
The `/etc/apache2/conf-available` directory contains additional configuration files that not associated with a particular module. This directory holds specialized and local configuration files, and links to configuration files set up by other applications.
`echo "Alias /adminer.php /usr/share/adminer/adminer.php" | sudo tee /etc/apache2/conf-available/adminer.conf`\
The configuration files in the conf-available directory are not active unless enabled\
Enable the configuration in `/etc/apache2/conf-available/adminer.conf` and reload apache:
- `sudo a2enconf adminer.conf && sudo systemctl reload apache2`
Now we can access `http://127.0.0.1/adminer.php`
#### example: adding wallabag to apache server
- `cd cd /var/www/html`
- `sudo git clone https://github.com/wallabag/wallabag.git && cd wallabag`
- `sudo git checkout 2.3.8` or whatever version
Now
