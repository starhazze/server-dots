{ pkgs, config, ... }: {
  age.secrets.caddy-env = {
    file = ../secrets/cloudflare-dns-token.age;
    owner = "caddy";
  };
  
  systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.caddy-env.path;

  users.users.caddy.extraGroups = [ "akkoma" ];

  systemd.tmpfiles.rules = [
    "d /var/lib/akkoma/uploads 0750 akkoma akkoma - -"
    "a+ /var/lib/akkoma/uploads - - - - g:caddy:rx,d:g:caddy:r"
  ];
  systemd.services.caddy.serviceConfig.ReadOnlyPaths = [ "/var/lib/akkoma/uploads" ];

  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" "github.com/caddyserver/replace-response@v0.0.0-20241211194404-3865845790a7" ];
      hash = "sha256-oNigcrlq09e0EW1TiZm+RPcy/5asPkgi55Q3ry2yPlM=";
    };
  
    email = "vyteshark@protonmail.com";

    globalConfig = ''
      acme_dns cloudflare {env.CLOUDFLARE_DNS_TOKEN}
    '';

    extraConfig = ''
      (lemmy_routing) {
        @backend path_regexp ^/(api|pictrs|feeds|nodeinfo|\.well-known|c/|u/|post/|comment/)/.*
        reverse_proxy @backend 127.0.0.1:8536
      }

      (plausible) {
        replace </head> `<script defer data-domain="{args[0]}" src="https://plausible.kluge.cafe/js/script.hash.tagged-events.js"></script></head>`
      }
    '';

    virtualHosts = {
      "haze.kluge.cafe".extraConfig = ''
        root * /var/www/haze
        file_server
      '';
  
      "www.kluge.cafe".extraConfig = ''
        root * /var/www/microslop
        file_server
      '';

      "kluge.cafe".extraConfig = ''
        route {
          handle /.well-known/matrix/server {
            header Content-Type application/json
            header Access-Control-Allow-Origin *
            respond `{"m.server":"matrix.kluge.cafe:443"}` 200
          }

          handle /.well-known/matrix/client {
            header Content-Type application/json
            header Access-Control-Allow-Origin *
            respond `{"m.homeserver":{"base_url":"https://matrix.kluge.cafe"}}` 200
          }

  	  import plausible kluge.cafe

          reverse_proxy 127.0.0.1:3000 {
            header_up -Accept-Encoding
          }
	}
      '';

      "a.kluge.cafe".extraConfig = ''
        reverse_proxy 127.0.0.1:4000
      '';

      "a-img.kluge.cafe".extraConfig = ''
        root * /var/lib/akkoma/uploads
        file_server

        header Content-Security-Policy "default-src 'none'"
        header X-Content-Type-Options "nosniff"
        header X-Frame-Options "DENY"
      '';
  
      "sharkey.lol".extraConfig = ''
        redir https://kluge.cafe{uri} permanent
      '';

      "home.kluge.cafe".extraConfig = ''
        reverse_proxy 127.0.0.1:5678
      '';
  
      "kuma.kluge.cafe".extraConfig = ''
        reverse_proxy http://127.0.0.1:3001 {
          transport http {
            versions 1.1
            keepalive off
          }
      
          header_up Host {upstream_hostport}
        }
      '';

      "matrix.kluge.cafe".extraConfig = ''
        reverse_proxy http://127.0.0.1:6167
      '';
    };
  };
}
