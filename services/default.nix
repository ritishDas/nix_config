{pkgs,lib}:
{
        dbus = { enable = true; };
        libinput.enable = true;
        openssh.enable = true;
        udev.packages = [ pkgs.libmtp ];
}//
import ./login.nix {inherit pkgs;}//
import ./audio.nix {}//
import ./postgres.nix {inherit pkgs;}

