{pkgs}:
{
    greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${pkgs.tuigreet}/bin/tuigreet --remember --cmd Hyprland";
                user = "ritish";
            };
        };
    };
    }
