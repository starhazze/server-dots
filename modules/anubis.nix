{ config, ... }: {

  systemd.services.caddy.serviceConfig = {
    RuntimeDirectory = "caddy";
    RuntimeDirectoryMode = "0755";
  };

  services.anubis.instances = {
    fourget = {
      enable = true;
      settings = {
        BIND_NETWORK = "tcp";
        BIND = "127.0.0.1:8923"; 
        TARGET = "unix:///run/caddy/4get-backend.sock"; 
        COOKIE_DOMAIN = "kluge.cafe";
        SERVE_ROBOTS_TXT = true;
      };
    };
  };

  services.caddy.virtualHosts = {
    "4get.kluge.cafe" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8923
      '';
    };

    "http://:8080" = {
      extraConfig = ''
        bind unix//run/caddy/4get-backend.sock|0666

        root * /var/lib/4get/www

        php_fastcgi unix/${config.services.phpfpm.pools."4get".socket} {
          try_files {path} {path}.php {path}/index.php index.php
        }

        file_server
      '';
    };
  };
}
