{ config, lib, ... }:
let
  lemmy = {
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

  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers = {
    photon = {
      image = "ghcr.io/xyphyn/photon:latest-node";
      ports = [ "127.0.0.1:3003:3000" ];
      environment = {
        PUBLIC_INSTANCE_URL = lemmy.domain;
        PUBLIC_SSR_ENABLED = "true";
        PUBLIC_INTERNAL_INSTANCE = "https://${lemmy.domain}";
      };
    };

    blorp = {
      image = "ghcr.io/blorp-labs/blorp:latest";
      ports = [ "127.0.0.1:3002:80" ];
      environment = {
        REACT_APP_DEFAULT_INSTANCE = "https://${lemmy.domain}";
        REACT_APP_LOCK_TO_DEFAULT_INSTANCE = "1";
      };
    };
  };

  services.postgresql.authentication = lib.mkAfter ''
    host lemmy lemmy 127.0.0.1/32 trust
  '';

  services.caddy.virtualHosts = {
    "lm.kluge.cafe".extraConfig = ''
      @ui_paths path /verify_email* /static/* /css/*
      reverse_proxy @ui_paths http://${lemmy.ip}:${toString config.services.lemmy.ui.port}

      reverse_proxy 127.0.0.1:8536
    '';

    "lemmy.kluge.cafe".extraConfig = ''
      file_server
      root * /var/www/lemmy
    '';

    "blorp.kluge.cafe".extraConfig = ''
      reverse_proxy 127.0.0.1:3002
      import lemmy_routing
    '';

    "photon.kluge.cafe".extraConfig = ''
      reverse_proxy 127.0.0.1:3003
      import lemmy_routing
    '';

    "lemmy-ui.kluge.cafe".extraConfig = ''
      reverse_proxy 127.0.0.1:1234
      import lemmy_routing
    '';
  };


  age.secrets.lemmy-smtp.file = ./secrets/lemmy-smtp.age;
  age.secrets.pictrs-api-key.file = ./secrets/pictrs-api-key.age;
  age.secrets.lemmy-admin-pass.file = ./secrets/lemmy-admin-pass.age;

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
      setup = {
        admin_username = "admin";
        site_name = "Kluge Lemmy";
      };
    };
  };
}
