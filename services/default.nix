{pkgs,lib}:
{
  dbus = { enable = true; };
  libinput.enable = true;
  gvfs.enable = true;
  preload.enable = true;
  logind = {lidSwitch = "ignore";};
  openssh.enable = true;
  udev.packages = [ pkgs.libmtp ];
}//
import ./login.nix {inherit pkgs;}//
import ./audio.nix {}//
import ./postgres.nix {inherit pkgs;}

