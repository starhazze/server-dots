{ config, pkgs, lib, ... }:
let
  lemmy = {
    dataDir = "/var/lib/lemmy";
    ip = "127.0.0.1";
    port = 8536;
    domain = "lm.kluge.cafe";
  };

  pict-rs = {
    ip = "127.0.0.1";
    port = 8080;
  };
in {
  services.pict-rs = {
    enable = true;
    port = pict-rs.port;
    address = pict-rs.ip;
  };

  systemd.services.lemmy = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
    environment = {
      LEMMY_DATABASE_URL = lib.mkForce "postgresql://lemmy@127.0.0.1:${toString config.services.postgresql.settings.port}/lemmy";
    };
  };

  services.caddy.virtualHosts."lm.kluge.cafe".extraConfig = ''
    handle /verify_email* {
      reverse_proxy http://${lemmy.ip}:${toString config.services.lemmy.ui.port}
    }

    handle /static/* {
      reverse_proxy http://${lemmy.ip}:${toString config.services.lemmy.ui.port}
    }

    handle /css/* {
      reverse_proxy http://${lemmy.ip}:${toString config.services.lemmy.ui.port}
    }

    reverse_proxy 127.0.0.1:8536
  '';

  services.caddy.virtualHosts."pf.kluge.cafe".extraConfig = ''
    reverse_proxy /notifications* localhost:8040
    reverse_proxy * localhost:8030
  '';

  services.caddy.virtualHosts."photon-pf.kluge.cafe".extraConfig = ''
    reverse_proxy /notifications* localhost:8040
    reverse_proxy * localhost:3004
  '';

  services.caddy.virtualHosts."blorp-pf.kluge.cafe".extraConfig = ''
    reverse_proxy /notifications* localhost:8040
    reverse_proxy * localhost:3005
  '';

  systemd.services.lemmy-ui = {
    environment = {
      LEMMY_UI_HOST = lib.mkForce "${lemmy.ip}:${toString config.services.lemmy.ui.port}";
      LEMMY_DATABASE_URL = lib.mkForce "postgresql://lemmy@localhost:${toString config.services.postgresql.settings.port}/lemmy";
      LEMMY_UI_LEMMY_INTERNAL_HOST = lib.mkForce "${lemmy.ip}:${toString lemmy.port}";
      LEMMY_UI_LEMMY_EXTERNAL_HOST = lib.mkForce lemmy.domain;
      LEMMY_UI_HTTPS = lib.mkForce "true";
    };
  };

  virtualisation.docker.enable = true;
  
  virtualisation.oci-containers.backend = "docker";
  
  virtualisation.oci-containers.containers = {
    photon = {
      image = "ghcr.io/xyphyn/photon:latest";
      ports = [ "127.0.0.1:3003:3000" ];
      environment = {
        PUBLIC_INSTANCE_URL = "lm.kluge.cafe";
        PUBLIC_SSR_ENABLED = "true";
        PUBLIC_INTERNAL_INSTANCE = "127.0.0.1:8536";
      };
    };

    blorp = {
      image = "ghcr.io/blorp-labs/blorp:latest";
      ports = [ "127.0.0.1:3002:80" ];
      environment = {
        REACT_APP_DEFAULT_INSTANCE = "https://lm.kluge.cafe";
        REACT_APP_LOCK_TO_DEFAULT_INSTANCE = "1";
      };
    };
  };

  services.postgresql.authentication = lib.mkAfter ''
    host lemmy lemmy 127.0.0.1/32 trust
  '';

  users.users.lemmy = {
    isSystemUser = true;
    group = "lemmy";
  };
  
  users.groups.lemmy = {};

  age.secrets.lemmy-smtp = {
    file = ./secrets/lemmy-smtp.age;
    owner = "lemmy";
  };

  age.secrets.pictrs-api-key = {
    file = ./secrets/pictrs-api-key.age;
    owner = "lemmy";
  };
  
  age.secrets.lemmy-admin-pass = {
    file = ./secrets/lemmy-admin-pass.age;
    owner = "lemmy";
  };

  services.lemmy = {
    enable = true;
    database.createLocally = true;

    smtpPasswordFile = config.age.secrets.lemmy-smtp.path;
    pictrsApiKeyFile = config.age.secrets.pictrs-api-key.path;
    adminPasswordFile = config.age.secrets.lemmy-admin-pass.path;

    settings = {
      hostname = lemmy.domain;
      bind = lemmy.ip;
      port = lemmy.port;
      tls_enabled = true;
      email = {
        smtp_server = "smtp-relay.brevo.com:587";
	smtp_login = "a2878c001@smtp-brevo.com";
	smtp_from_address = "noreply@kluge.cafe";
	tls_type = "none";
      };
      database = {
        user = "lemmy";
        host = "localhost";
        port = config.services.postgresql.settings.port;
        database = "lemmy";
        pool_size = 5;
      };
      pictrs = {
        url = "http://${pict-rs.ip}:${toString pict-rs.port}/";
      };
      setup = {
        admin_username = "admin";
        site_name = "Kluge Lemmy";
      };
    };
  };

  system.activationScripts."make_sure_lemmy_user_owns_files" = ''
    dir='${lemmy.dataDir}'
    mkdir -p "''${dir}"
  
    if [[ "$(${pkgs.toybox}/bin/stat "''${dir}" -c '%U:%G' | tee /dev/stderr)" != "lemmy:lemmy" ]]; then
      chown -R lemmy:lemmy "''${dir}"
    fi
  '';
}
