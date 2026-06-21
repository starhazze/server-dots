{ ... }: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 443 22 ];
    allowedUDPPortRanges = [ ];
  };

  age.identityPaths = [ "/root/.ssh/id_ed25519" ];

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [{ command = "ALL"; options = []; }];
      groups = [ "wheel" ];
    }];
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
  };

  #  - flaky af
  #  services.fail2ban.jails.caddy-auth.settings = {
  #    enabled = true;
  #    filter = "caddy-auth";
  #    logpath = "/var/log/caddy/*.log";
  #    backend = "auto";
  #    maxretry = 5;
  #    findtime = "10m";
  #    bantime = "1h";
  #    action = "iptables-multiport[name=caddy-auth, port=\"80,443\"]";
  #  };

  # environment.etc."fail2ban/filter.d/caddy-auth.conf".text = ''
  #   [Definition]
  #   failregex = "client_ip":"<HOST>".*"status":40[13]
  #   ignoreregex =
  # '';
}
