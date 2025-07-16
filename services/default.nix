{pkgs,lib}:
{
    dbus = { enable = true; };
    libinput.enable = true;
    openssh.enable = true;
}//
import ./login.nix {inherit pkgs;}//
import ./audio.nix {}//
import ./postgres.nix {inherit pkgs;}

