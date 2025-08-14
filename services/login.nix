{pkgs}:
{
    greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --cmd Hyprland";
                user = "ritish";
            };
        };
    };
    }
