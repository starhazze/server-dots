{ config, pkgs, ... }: {
  systemd.services.backup = {
    description = "backup (R2) script";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "/root/backup.sh";
    };
    path = with pkgs; [
      gzip
      gnupg
      rclone
      postgresql
      sudo
      gnutar
    ];
  };
  
  systemd.timers.backup = {
    description = "backup (R2) timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  age.secrets.matrix-notify-token = {
    file = ../secrets/matrix-notify-token.age;
    owner = "root";
  };
  
  systemd.services."notify-matrix@" = {
    description = "notify about failed services";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "notify-matrix" ''
        set -euo pipefail
        TOKEN=$(cat ${config.age.secrets.matrix-notify-token.path})
        ROOM_ID="!0g7zgfM_uQX1a5Jeggvgu8jCU8vyoAor-x8nalGqZIc"
        MSG="shite, service failed: $1 on ${config.networking.hostName}"
        RESP=$(${pkgs.curl}/bin/curl -s -w "\nHTTP_STATUS:%{http_code}" -X PUT \
          -H "Authorization: Bearer $TOKEN" \
          -H "Content-Type: application/json" \
          -d "{\"msgtype\":\"m.text\",\"body\":\"$MSG\"}" \
            "https://matrix.kluge.cafe/_matrix/client/v3/rooms/$ROOM_ID/send/m.room.message/$(date +%s%N)")
        echo "$RESP"
      ''} %i";
    };
  };
  
  systemd.services.backup.onFailure = [ "notify-matrix@%n.service" ];

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
}
