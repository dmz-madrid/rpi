#### enable ssh

    sudo apt install openssh-server
    sudo service ssh start

### LEMP stack in raspbian 10

base install: https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mariadb-php-lemp-stack-on-debian-10 \
some dependencies added
1. nginx
```
    sudo apt update && sudo apt install nginx
    sudo apt install software-properties-common
```
2. requeriments
```
    sudo apt install -y php php-mysql
    sudo apt install -y php-common php-bcmath php-fpm php-xml php-zip php-curl php-mbstring php-gd php-tidy
    # this also installs libtidy5deb1 php7.3-tidy
    sudo apt install -y php-mbstring php-mysql php-json php-curl php-bcmath php-zip
    # php-pdo not necessary, or it will switch to manual
```
3. composer
```
    sudo apt install -y curl php-cli php-mbstring git unzip
    cd ~ && curl -sS https://getcomposer.org/installer -o composer-setup.php
```
To install composer as a system-wide command named `composer`, under `/usr/local/bin`:
```
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
```    
Output:
```
    All settings correct for using Composer
    Downloading...
    Composer (version 1.9.1) successfully installed to: /usr/local/bin/composer
    Use it: php /usr/local/bin/composer
    $ composer -V
    Composer version 1.9.1 2019-11-01 17:20:17
```
4. mariadb
```
    sudo apt install -y mariadb-server
    sudo mysql_secure_installation
```    
5. Apache Virtual Hosts
By default, Apache(and nginx) serves its content from a directory located at `/var/www/html`, using the configuration contained in `/etc/apache2/sites-available/000-default.conf`\
Virtual hosts enable us to keep multiple websites hosted on a single Apache server.

To try new websites, may be necessary to disable the default website that comes installed with Apache.\
This is required if you’re not using a custom domain name, because in this case Apache’s default configuration would overwrite your Virtual Host.\
To disable Apache’s default website, type:
```
    sudo a2dissite 000-default
```
Alternatively you can edit hosts file `/etc/hosts/`
```bash
127.0.1.1       server1.com www.server1.com
```
Then access the newly created virtual host with `http://server1.com`

6. Adminer
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

7. example: adding wallabag to apache server
```
    cd cd /var/www/html
    # don't use sudo with git clone or you won't have permission to make install
    git clone https://github.com/wallabag/wallabag.git && cd wallabag
    sudo git checkout 2.3.8 # or whatever version
    sudo mysql -u root -p

    create user wallabaguser@localhost;
    set password for wallabaguser@localhost= password("your-password");
    grant all privileges on wallabag.* to wallabaguser@localhost identified by 'your-password';
    flush privileges;
    exit;
``` 
Each time you make some changes in `app/config/parameters.yml`, empty the wallabag cache to take the modification into account:
- `php bin/console wallabag:install --env=prod`
- `sudo -u www-data php bin/console cache:clear -e prod`


#### Address resolution
Edit hosts file `/etc/hosts/` to test the servers locally first.

```
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters

# local nginx server blocks addresses

127.0.1.1       raspberrypi
127.0.1.1       server1.com www.server1.com
127.0.0.1       example.com www.example.com
127.0.0.1       domain
```


