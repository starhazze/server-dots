{ modulesPath, pkgs, inputs, config, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
    ./modules/minecraft.nix

    ./modules/anubis.nix
    ./modules/caddy.nix
    ./modules/glance.nix

    ./modules/lemmy.nix
    ./modules/akkoma.nix
    ./modules/akkoma-blocklist.nix
    ./modules/4get.nix
    ./modules/sharkey.nix
    ./modules/continuwuity.nix

    inputs.nix-minecraft.nixosModules.minecraft-servers
    inputs.agenix.nixosModules.default
    { nixpkgs.overlays = [ inputs.nix-minecraft.overlay ]; }
  ];

  services.qemuGuest.enable = true;
  services.uptime-kuma.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 443 22 ];
    allowedUDPPortRanges = [ ];
  };

  age.identityPaths = [ "/root/.ssh/id_ed25519" ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKU5Apez86vNAvvkHKiAeyMOvzkC0qdabZyE1foEOqw starhaze@nixos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDpunBRSAcd2UfW1gq93xTAMDVDhD9HVWdBH1FSvjRR screamdev любит фембоев"
  ];

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [{ command = "ALL"; options = []; }];
      groups = [ "wheel" ];
    }];
  };

  users = {
    defaultUserShell = pkgs.fish;
    users.starhaze = {
      isNormalUser = true;
      description = "starhaze";
      shell = pkgs.fish;
      extraGroups = [ "wheel" ];
    };
  };

  programs.fish = { enable = true; interactiveShellInit = ''set fish_greeting''; };

  nix.settings.experimental-features = ["nix-command" "flakes"]; 

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.x86_64-linux.default
    config.services.akkoma.package
    neovim
    git
    fishPlugins.fzf-fish
    rclone
    fzf
    mcrcon
    dart-sass
  ];

  systemd.services.backup = {
    description = "backup (R2) script";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "/root/backup.sh";
    };
  };
  
  systemd.timers.backup = {
    description = "backup (R2) timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.backup-fi = {
    description = "backup (FI) script";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "/root/backup-fi.sh";
    };
  };
  
  systemd.timers.backup-fi = {
    description = "backup (FI) timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.sass-watch = {
    description = "sass watcher";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.dart-sass}/bin/sass --watch /var/www/haze/style.scss:/var/www/haze/style.css";
      Restart = "on-failure";
      RestartSec = "5s";
      User = "root";
    };
  };

  # --- ---

  boot.loader.grub.enable = true;

  networking.hostName = "nixos-de";
  networking.useDHCP = false;
  networking.interfaces.ens3 = {
    ipv4.addresses = [{
      address = "193.58.122.155";
      prefixLength = 32;
    }];
  };
  networking.defaultGateway = {
    address = "10.0.0.1";
    interface = "ens3";
  };
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.localCommands = ''
    ip route add 10.0.0.1/32 dev ens3 scope link || true
  '';

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "26.05";
}
