https://stackoverflow.com/questions/41637076/http2-with-node-js-behind-nginx-proxy



In general, the biggest immediate benefit of HTTP/2 is the speed increase offered by multiplexing for the browser connections which are often hampered by high latency (i.e. slow round trip speed). These also reduce the need (and expense) of multiple connections which is a work around to try to achieve similar performance benefits in HTTP/1.1.

For internal connections (e.g. between webserver acting as a reverse proxy and back end app servers) the latency is typically very, very, low so the speed benefits of HTTP/2 are negligible. Additionally each app server will typically already be a separate connection so again no gains here.

So you will get most of your performance benefit from just supporting HTTP/2 at the edge. This is a fairly common set up - similar to the way HTTPS is often terminated on the reverse proxy/load balancer rather than going all the way through.

However there are potential benefits to supporting HTTP/2 all the way through. For example it could allow server push all the way from the application. Also potential benefits from reduced packet size for that last hop due to the binary nature of HTTP/2 and header compression. Though, like latency, bandwidth is typically less of an issue for internal connections so importance of this is arguable. Finally some argue that a reverse proxy does less work connecting a HTTP/2 connect to a HTTP/2 connection than it would to a HTTP/1.1 connection as no need to convert one protocol to the other, though I'm sceptical if that's even noticeable since they are separate connections (unless it's acting simply as a TCP pass through proxy). So, to me, the main reason for end to end HTTP/2 is to allow end to end Server Push, but even that is probably better handled with HTTP Link Headers and 103-Early Hints due to the complications in managing push across multiple connections.

For now, while servers are still adding support and server push usage is low (and still being experimented on to define best practice), I would recommend only to have HTTP/2 at the end point. Nginx also doesn't, at the time of writing, support HTTP/2 for ProxyPass connections (though Apache does), and has no plans to add this, and they make an interesting point about whether a single HTTP/2 connection might introduce slowness (emphasis mine):

    Is HTTP/2 proxy support planned for the near future?

    Short answer:

    No, there are no plans.

    Long answer:

    There is almost no sense to implement it, as the main HTTP/2 benefit is that it allows multiplexing many requests within a single connection, thus [almost] removing the limit on number of simalteneous requests - and there is no such limit when talking to your own backends. Moreover, things may even become worse when using HTTP/2 to backends, due to single TCP connection being used instead of multiple ones.

    On the other hand, implementing HTTP/2 protocol and request multiplexing within a single connection in the upstream module will require major changes to the upstream module.

    Due to the above, there are no plans to implement HTTP/2 support in the upstream module, at least in the foreseeable future. If you still think that talking to backends via HTTP/2 is something needed - feel free to provide patches.

Finally, it should also be noted that, while browsers require HTTPS for HTTP/2 (h2), most servers don't and so could support this final hop over HTTP (h2c). So there would be no need for end to end encryption if that is not present on the Node part (as it often isn't). Though, depending where the backend server sits in relation to the front end server, using HTTPS even for this connection is perhaps something that should be considered if traffic will be travelling across an unsecured network (e.g. CDN to origin server across the internet).

https://www.nginx.com/blog/http2-module-nginx/#testpage
