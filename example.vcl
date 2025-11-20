vcl 4.1;

import std;
import directors;

backend default {
  .host = "127.0.0.1";
  .port = "8080";
  .connect_timeout = 5s;
  .first_byte_timeout = 30s;
  .between_bytes_timeout = 5s;
  .probe = {
    .url = "/health";
    .interval = 5s;
    .timeout = 2s;
    .window = 5;
    .threshold = 3;
  }
}

backend backend2 {
  .host = "192.168.1.100";
  .port = "8080";
}

acl purge {
  "localhost";
  "192.168.0.0"/24;
}

sub vcl_init {
  new vdir = directors.round_robin();
  vdir.add_backend(default);
  vdir.add_backend(backend2);
}

sub vcl_recv {
  # Remove cookies for static files
  if (req.url ~ "\.(jpg|jpeg|png|gif|css|js|ico)$") {
    unset req.http.Cookie;
  }

  # Pass requests with Authorization header
  if (req.http.Authorization) {
    return (pass);
  }

  # Handle PURGE requests
  if (req.method == "PURGE") {
    if (client.ip !~ purge) {
      return (synth(405, "Not allowed"));
    }
    return (purge);
  }

  # Use director for load balancing
  set req.backend_hint = vdir.backend();

  # Normalize Accept-Encoding header
  if (req.http.Accept-Encoding) {
    if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)$") {
      unset req.http.Accept-Encoding;
    } elsif (req.http.Accept-Encoding ~ "gzip") {
      set req.http.Accept-Encoding = "gzip";
    } elsif (req.http.Accept-Encoding ~ "deflate") {
      set req.http.Accept-Encoding = "deflate";
    } else {
      unset req.http.Accept-Encoding;
    }
  }

  return (hash);
}

sub vcl_backend_response {
  # Cache static files for 1 hour
  if (bereq.url ~ "\.(jpg|jpeg|png|gif|css|js)$") {
    set beresp.ttl = 1h;
    unset beresp.http.Set-Cookie;
  }

  # Enable ESI processing
  if (beresp.http.Content-Type ~ "text/html") {
    set beresp.do_esi = true;
  }

  return (deliver);
}

sub vcl_deliver {
  # Add cache hit/miss header
  if (obj.hits > 0) {
    set resp.http.X-Cache = "HIT";
    set resp.http.X-Cache-Hits = obj.hits;
  } else {
    set resp.http.X-Cache = "MISS";
  }

  # Remove internal headers
  unset resp.http.X-Varnish;
  unset resp.http.Via;
  unset resp.http.Age;

  return (deliver);
}

sub vcl_synth {
  if (resp.status == 405) {
    set resp.http.Content-Type = "text/plain";
    synthetic("Method not allowed");
    return (deliver);
  }
}
