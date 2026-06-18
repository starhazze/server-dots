{ config, pkgs, lib, inputs, ... }: {

  age.secrets.minecraft-env = {
    file = ../secrets/minecraft-env.age;
    owner = "minecraft";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "minecraft-server"
  ];

  # yes i run a minecraft server on prod :D
  # gonna remove it when the project actually gets some kind of attention though
  services.minecraft-servers = {
    enable = true;
    eula = true;
    environmentFile = config.age.secrets.minecraft-env.path;
    openFirewall = true;
    servers.fabric = {
      enable = true;
      package = pkgs.fabricServers.fabric-26_1_2.override {
        jre_headless = pkgs.openjdk25_headless;
      };
      serverProperties = {
        enable-rcon = true;
        "rcon.port" = 25575;
        "rcon.password" = "@RCON_PASS@";
      };
    };
  };
}
