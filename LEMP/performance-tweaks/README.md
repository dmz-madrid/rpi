## USING HTTP1.1 in the communication nginx proxy-docker webapp

We add the #### marked lines to the proxy.

```
location / {
        proxy_http_version 1.1; # can't proxy HTTP2 ####
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   Host      $http_host;
        proxy_pass         http://127.0.0.1:port;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Connection ""; # keepalive HTTP1.1 ####
    }
```

## USING Expires-header
Expires header for static assets in Nginx can boost the performance. We can use https://tools.pingdom.com/ to test the server's performance.

Info:
https://veerasundar.com/blog/2014/09/setting-expires-header-for-assets-nginx/
https://www.digitalocean.com/community/questions/add-cache-control-header-expire-header-in-nginx


### Without expires header this was the page score

![Without](https://github.com/dmz-madrid/rpi/blob/master/LEMP/expires-header/without-expires-header.jpg)


Added this part to `/etc/nginx/sites-available/webapp.conf` with expires-header. Should look like this
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



    #           http2; #if you want  ####
    #             v (insert here at the end)
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

    listen 80; # http2; # if you want, put http2 after the port 80 to force use http2 ####
    server_name myserver.ddns.net;
    return 404; # managed by Certbot
}
```
### After adding expires header the score was better

![With](https://github.com/dmz-madrid/rpi/blob/master/LEMP/expires-header/with-expires-header.jpg)

### Now we use everything

- HTTP1.1 in the local communication between nginx proxy and dockerized webapp **(keepalive TCP)**
- HTTP2 in the communication between nginx proxy and clients **(higher compression, binary coded (instead of string) http parameters -> efficiency boost)**
- Expires-header in the communication between nginx proxy and clients **(use of cache)**

The result is this, much higher score:

![Everything](https://github.com/dmz-madrid/rpi/blob/master/LEMP/performance-tweaks/expires-hdr-http2-edge-http11proxy.jpg)



