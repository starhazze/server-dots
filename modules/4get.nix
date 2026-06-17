{ config, pkgs, lib, ... }:

let
  stateDir = "/var/lib/4get";
  webRoot  = "${stateDir}/www";

  fourgetSrc = pkgs.fetchgit {
    url  = "https://git.lolcat.ca/lolcat/4get";
    rev  = "5a7cecef11d4b728ba202e1a80f5a77b7aee88fe";
    hash = "sha256-QnzNE3zNVKs0+JggnhNymRmZIUcyKbUGXtj0L5CY7s0=";
  };

  phpPackage = pkgs.php.withExtensions ({ enabled, all }: enabled ++ [
    all.apcu
    all.curl
    all.dom
    all.imagick
  ]);

in {
  users.users."4get" = {
    isSystemUser = true;
    group        = "4get";
    home         = stateDir;
  };
  users.groups."4get" = {};
  users.users.caddy.extraGroups = [ "4get" ];

  systemd.tmpfiles.rules = [
    "d ${stateDir}      0750 4get 4get -"
    "d ${webRoot}       0755 4get 4get -"
    "d ${webRoot}/icons 0755 4get 4get -"
    "d ${webRoot}/data  0755 4get 4get -" 
  ];

  systemd.services."4get-sync" = {
    description   = "Sync 4get source to state directory";
    wantedBy      = [ "multi-user.target" ];
    before        = [ "phpfpm-4get.service" ];
    after         = [ "systemd-tmpfiles-setup.service" ];

    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = true;
      # runs as root so it can chown after rsync
    };

    script = ''
      chmod 750 ${stateDir}
      chown 4get:4get ${stateDir}

      config_backup=""
      if [ -f ${webRoot}/data/config.php ]; then
        config_backup=$(cat ${webRoot}/data/config.php)
      fi

      ${pkgs.rsync}/bin/rsync -rl --delete \
        --no-perms \
        --chmod=D755,F644 \
        --exclude='/icons/' \
        --exclude='/data/config.php' \
        ${fourgetSrc}/ ${webRoot}/

      chown -R 4get:4get ${webRoot}
      chmod -R u+w ${webRoot}

      if [ -n "$config_backup" ]; then
        echo "$config_backup" > ${webRoot}/data/config.php
      else
        cp ${fourgetSrc}/data/config.php ${webRoot}/data/config.php
        echo "[4get] Seeded config from source. Edit ${webRoot}/data/config.php."
      fi
    '';
  };

  services.phpfpm.pools."4get" = {
    user       = "4get";
    group      = "4get";
    phpPackage = phpPackage;

    settings = {
      "listen.owner"          = config.services.caddy.user;
      "listen.group"          = config.services.caddy.group;
      "pm"                    = "dynamic";
      "pm.max_children"       = 10;
      "pm.start_servers"      = 2;
      "pm.min_spare_servers"  = 1;
      "pm.max_spare_servers"  = 5;
      "pm.max_requests"       = 500;
    };

    phpOptions = ''
      apc.enabled  = 1
      apc.shm_size = 64M
    '';
  };

  services.caddy.virtualHosts."4get.kluge.cafe" = {
    extraConfig = ''
      root * ${webRoot}

      php_fastcgi unix/${config.services.phpfpm.pools."4get".socket} {
        try_files {path} {path}.php {path}/index.php index.php
      }

      file_server
    '';
  };
}
