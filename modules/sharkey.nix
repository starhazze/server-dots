{ config, ... }: {
  services.sharkey = {
    enable = true;
    openFirewall = false;

    setupPostgresql = true;
    setupRedis = true;

    settings = {
      url = "https://kluge.cafe";
      port = 3000;
      mediaDirectory = "/var/lib/sharkey/media";
      cacheRemoteFiles = true;
      cacheRemoteSensitiveFiles = false;
      # the rest of the configuration is from db, grr.. i changed too much shit to transfer it all here now
    };
  };
}
