{ pkgs, config, ... }: {
  age.secrets.caddy-env = {
    file = ./secrets/cloudflare-dns-token.age;
    owner = "caddy";
  };
  
  systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.caddy-env.path;

  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-bzMqxWTqrJ1skZmRTXyEMCKStXpljbqe5r0Ve2cnBfM=";
    };
  
    email = "vyteshark@protonmail.com";

    globalConfig = ''
      acme_dns cloudflare {env.CLOUDFLARE_DNS_TOKEN}
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
        reverse_proxy 127.0.0.1:3000

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
      '';

      "a.kluge.cafe".extraConfig = ''
        reverse_proxy 127.0.0.1:4000
      '';
  
      "sharkey.lol".extraConfig = ''
        redir https://kluge.cafe{uri} permanent
      '';

      "lemmy.kluge.cafe".extraConfig = ''
        file_server
	root * /var/www/lemmy
      '';

      "blorp.kluge.cafe".extraConfig = ''
        reverse_proxy 127.0.0.1:3002

        @backend path_regexp ^/(api|pictrs|feeds|nodeinfo|\.well-known|c/|u/|post/|comment/)/.*
        reverse_proxy @backend 127.0.0.1:8536
      '';

      "photon.kluge.cafe".extraConfig = ''
        reverse_proxy 127.0.0.1:3003

        @backend path_regexp ^/(api|pictrs|feeds|nodeinfo|\.well-known|c/|u/|post/|comment/)/.*
        reverse_proxy @backend 127.0.0.1:8536
      '';

      "lemmy-ui.kluge.cafe".extraConfig = ''
        reverse_proxy 127.0.0.1:1234

        @backend path_regexp ^/(api|pictrs|feeds|nodeinfo|\.well-known|c/|u/|post/|comment/)/.*
        reverse_proxy @backend 127.0.0.1:8536
      '';
  
      "cockpit.maybequic.xyz".extraConfig = ''
        reverse_proxy 127.0.0.1:9090
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
  users.users.caddy.extraGroups = [ "mastodon" ];
}
