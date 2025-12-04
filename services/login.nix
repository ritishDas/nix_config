{pkgs}: {
  greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet \
          --remember \
          --time \
          --user ritish \
          --cmd Hyprland";
        user = "ritish";
      };
    };
  };
}
