{pkgs,lib}:
{
  dbus = { enable = true; };
  libinput.enable = true;
  gvfs.enable = true;
  logind = {settings.Login.HandleLidSwitch = "ignore";};
  openssh.enable = true;
  udev.packages = [ pkgs.libmtp ];
  udev.extraRules = ''
    KERNEL=="uinput",MODE="0660", GROUP="input"
    '';

}//
import ./login.nix {inherit pkgs;}//
import ./audio.nix {}//
import ./postgres.nix {inherit pkgs;}

