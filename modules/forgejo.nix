{ ... }: {
  services.forgejo = {
    enable = true;
    settings = {
      server = {
        HTTP_PORT = 6000;
        HTTP_ADDR = "127.0.0.1";
        DOMAIN = "git.kluge.cafe";
	ROOT_URL = "https://git.kluge.cafe/";
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
    };
  };

  services.caddy.virtualHosts."git.kluge.cafe".extraConfig = ''
    import log forgejo
    route {
      import plausible git.kluge.cafe
      reverse_proxy 127.0.0.1:6000
    }
  '';
}
