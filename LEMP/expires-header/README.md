Expires header for static assets in Nginx
https://veerasundar.com/blog/2014/09/setting-expires-header-for-assets-nginx/
https://www.digitalocean.com/community/questions/add-cache-control-header-expire-header-in-nginx
s
```
# This is a proxy for a dockerized web app

server {
    server_name myserver.ddns.net;

    location /.well-known/ {
        root /var/www/html;
    }

    location / {
        proxy_http_version 1.1; # can't proxy HTTP2 ####
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   Host      $http_host;
        proxy_pass         http://127.0.0.1:port;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Connection ""; # keepalive HTTP1.1 ####
        if ($request_uri ~* ".(ico|css|js|gif|jpe?g|png)$") {
                                        expires 30d;
                                        access_log off;
                                        add_header Pragma public;
                                        add_header Cache-Control "public";
                                        break;
        }
    }



    #        http2; #if you want  ####
    #         v (insert here)
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/myserver.ddns.net/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/myserver.ddns.net/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
# Certbot will add this automatically

server {
    if ($host = myserver.ddns.net) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    listen 80; # http2; # if you want ####
    server_name myserver.ddns.net;
    return 404; # managed by Certbot
}
```
