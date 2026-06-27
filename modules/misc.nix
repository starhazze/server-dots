{ config, ... }: {
  environment.variables.ZELLIJ_CONFIG_DIR = "/etc/zellij";
  
  environment.etc."zellij/config.kdl".text = ''
    on_force_close "detach"
  '';

  environment.etc."zellij/layouts/bare.kdl".text = ''
    layout {
      pane
      pane size=1 borderless=true {
        plugin location="zellij:status-bar"
      }
    }
  '';
}
