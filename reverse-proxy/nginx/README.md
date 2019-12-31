https://serverfault.com/questions/561892/how-to-handle-relative-urls-correctly-with-a-reverse-proxy/561897#561897
https://serverfault.com/questions/561892/how-to-handle-relative-urls-correctly-with-a-reverse-proxy/561897#561897
https://serverfault.com/questions/932628/how-to-handle-relative-urls-correctly-with-a-nginx-reverse-proxy

> The problem is basically that using a proxy_pass directive won't rewrite HTML code and therefor relative URL's to for instance a img src="/assets/image.png" won't magically change to img src="/bbb/assets/image.png".

> I wrote about potential strategies to address that in Apache httpd here and similar solutions are possible for nginx as well:

    If you have control over example.com and the how the application/content is deployed there, deploy in the same base URI you want to use on example.net for the reverse proxy
    --> deploy your code in example.com/bbb and then your proxy_pass will become quite an easy as /assets/image.png will have been moved to /bbb/assets/image.png:
```
    location /bbb/ {
         proxy_pass http://example.com/bbb/; 
```
    If you have control over example.com and the how the application/content is deployed:
    change to relative paths, i.e. rather than img src="/assets/image.png"
    refer to img src="./assets/image.png" from a page example.com/index.html
    and to img src="../../assets/image.png"from a page example.com/some/path/index.html

    Maybe you're lucky and example.com only uses a few URI paths in the root and non of those are used by example.net, then simply reverse proxy every necessary subdirectory:
```
    location /bbb/ {
         proxy_pass http://example.com/; 
    }
    location /assets/ {
         proxy_pass http://example.com/asssets/; 
    }
    location /styles/ {
         proxy_pass http://example.com/styles/; 

    give up using a example.com as subdirectory on example.net and instead host it on a subdomain of example.net:

    server { 
      server_name bbb.example.net 
      location / {
         proxy_pass http://example.com/; 
      }
    }

    rewrite the (HTML) content by enabling the nginx ngx_http_sub_module. That will also allow you to rewrite absolute URL's with something similar to:

    location /bbb/ {
         sub_filter 'src="/assets/'  'src="/bbb/assets/';
         sub_filter 'src="http://example.com/js/' 'src="http://www.example.net/bbb/js/' ;
         sub_filter_once off;
         proxy_pass http://example.com/; 
    }
```


https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/
