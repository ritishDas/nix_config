{pkgs}:
{
    greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
                user = "ritish";
            };
        };
    };
    }
