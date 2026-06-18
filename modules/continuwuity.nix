{ config, ... }: {
  services.matrix-continuwuity = {
    enable = true;
    settings.global = {
      server_name = "kluge.cafe";
      database_backend = "rocksdb";
      allow_registration = true;
      registration_token_required = true;
      auto_join_rooms = [ "#space:kluge.cafe" "#announcements:kluge.cafe" ];
    };
  };
}
