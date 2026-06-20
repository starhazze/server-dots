{ ... }: {
  environment.etc."fail2ban/filter.d/caddy-auth.conf".text = ''
    [Definition]
    failregex = "client_ip":"<HOST>".*"status":40[13]
    ignoreregex =
  '';

  services.fail2ban.jails.caddy-auth.settings = {
    enabled = true;
    filter = "caddy-auth";
    logpath = "/var/log/caddy/*.log";
    backend = "auto";
    maxretry = 5;
    findtime = "10m";
    bantime = "1h";
    action = "iptables-allports";
  };
}
