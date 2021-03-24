{ config, lib, pkgs, netcfg, ... }:

{
  services.varnish.enable = true;
  services.varnish.http_address = "127.0.0.1:6081";
  services.varnish.config = ''
# This is a basic VCL configuration file for varnish.  See the vcl(7)
# man page for details on VCL syntax and semantics.
#
# Default backend definition.  Set this to point to your content
# server.
#
backend default {
    .host = "10.5.1.20";
    .port = "80";
}
#
# Below is a commented-out copy of the default VCL logic.  If you
# redefine any of these subroutines, the built-in logic will be
# appended to your code.
#

sub vcl_recv {
     set req.grace = 1m;
     unset req.http.Cookie;
     unset req.http.Authorization;

     if (req.http.x-forwarded-for) {
        set req.http.X-Forwarded-For = req.http.X-Forwarded-For ", " client.ip;
    } else {
        set req.http.X-Forwarded-For = client.ip;
  }


    if (req.request != "GET" &&
      req.request != "HEAD" &&
      req.request != "PUT" &&
      req.request != "POST" &&
      req.request != "TRACE" &&
      req.request != "OPTIONS" &&
      req.request != "DELETE") {
        #/* Non-RFC2616 or CONNECT which is weird. */
        return (pipe);
    }
    if (req.request != "GET" && req.request != "HEAD") {
        #/* We only deal with GET and HEAD by default */
        return (pass);
    }
    if (req.http.Authorization || req.http.Cookie) {
        #/* Not cacheable by default */

    }
    if(req.http.X-No-Cache ~ "YES") {
      return(pass);
   }

  if (req.http.Accept-Encoding) {
    if (req.http.Accept-Encoding ~ "gzip") {
      set req.http.Accept-Encoding = "gzip";
    } elsif (req.http.Accept-Encoding ~ "deflate") {
      set req.http.Accept-Encoding = "deflate";
    } else {
      remove req.http.Accept-Encoding;
    }
  }

  return (lookup);
}

sub vcl_fetch {

    if (beresp.http.Cache-Control ~ "(no-cache|no-store|private|must-revalidate)") {
     return(pass);
    }
    if(beresp.status >= 300){
        return (pass);
    }
    if (beresp.ttl < 180s){
        set beresp.ttl = 180s;
    }
    set beresp.grace = 1m;
  remove beresp.http.Via;
  remove req.http.cookie;
  remove beresp.http.Set-Cookie;
    if (req.url ~ "\.(css|js|jpg|jpeg|gif|ico|png)$") {
        unset beresp.http.expires;
        set beresp.http.Cache-Control = "public, max-age=300";
  set beresp.http.age = "0";
  set beresp.http.expires = beresp.ttl;
    } else {
        # set beresp.http.cache-control = "private, max-age=0, must-revalidate";
        # set beresp.http.pragma = "no-cache";
    }
  # only cache successful requests
    return(deliver);
}

sub vcl_deliver {
  # This just inserts a diagnostic header to let us know if the content
  # was served via a cache hit, or whether it was a miss.

  if (obj.hits > 0) {
    set resp.http.X-Cache = "HIT";
  } else {
   set resp.http.X-Cache = "MISS";
  } 

    return (deliver);
}

sub vcl_error {
    set obj.http.Content-Type = "text/html; charset=utf-8";
    synthetic {"
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
  <head>
    <title>"} obj.status " " obj.response {"</title>
  </head>
  <body>
    <h1>Error "} obj.status " " obj.response {"</h1>
    <p>"} obj.response {"</p>
    <h3>Guru Meditation:</h3>
    <p>XID: "} req.xid {"</p>
    <hr>
    <address>
       <a href="http://www.varnish-cache.org/">Varnish cache server</a>
    </address>

</body>
</html>
"};
    return (deliver);
}
  '';
}
