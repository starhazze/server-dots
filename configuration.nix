{ modulesPath, pkgs, inputs, config, lib, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix

    ./modules/anubis.nix
    ./modules/caddy.nix
    ./modules/security.nix
    ./modules/systemd.nix
    ./modules/forgejo.nix

    ./modules/glance.nix

    ./modules/lemmy.nix
    ./modules/4get.nix
    ./modules/sharkey.nix
    ./modules/continuwuity.nix

    inputs.nix-minecraft.nixosModules.minecraft-servers
    inputs.agenix.nixosModules.default
    { nixpkgs.overlays = [ inputs.nix-minecraft.overlay ]; }
  ];

  services.qemuGuest.enable = true;
  services.uptime-kuma.enable = true;

  # stop hanging my rebuild every-single-fucking-time please :(
  systemd.services.dbus-broker.restartIfChanged = lib.mkForce false;
  systemd.services.dbus-broker.reloadIfChanged = lib.mkForce false;

  services.postgresql.settings = {
    shared_buffers = "1024MB";
    effective_cache_size = "3GB";
    work_mem = "4MB";
    maintenance_work_mem = "256MB";
    max_connections = 100;
  };

  users = {
    defaultUserShell = pkgs.fish;
    users.starhaze = {
      isNormalUser = true;
      description = "starhaze";
      shell = pkgs.fish;
      extraGroups = [ "wheel" ];
    };
    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKU5Apez86vNAvvkHKiAeyMOvzkC0qdabZyE1foEOqw starhaze@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDpunBRSAcd2UfW1gq93xTAMDVDhD9HVWdBH1FSvjRR screamdev любит фембоев"
    ];
    users.starhaze.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKU5Apez86vNAvvkHKiAeyMOvzkC0qdabZyE1foEOqw starhaze@nixos"
    ];
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
    gnupg
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  services.caddy.virtualHosts = lib.genAttrs [
    "haze.kluge.cafe"
    "www.kluge.cafe"
    "kluge.cafe"
    "git.kluge.cafe"
    "a.kluge.cafe"
    "a-img.kluge.cafe"
    "sharkey.lol"
    "home.kluge.cafe"
    "kuma.kluge.cafe"
    "matrix.kluge.cafe"
    "lm.kluge.cafe"
    "lemmy.kluge.cafe"
    "blorp.kluge.cafe"
    "photon.kluge.cafe"
    "lemmy-ui.kluge.cafe"
    "4get.kluge.cafe"
    "http://:8080"
  ] (name: { logFormat = null; });

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
