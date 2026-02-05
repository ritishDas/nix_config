{pkgs,lib}:
{
  dbus = { enable = true; };
  libinput.enable = true;
  gvfs.enable = true;
  tumbler.enable = true;
  logind = {settings.Login.HandleLidSwitch = "ignore";};
  openssh.enable = true;
  udev.packages = [ pkgs.libmtp ];
  udev.extraRules = ''
    KERNEL=="uinput",MODE="0660", GROUP="input"
    '';
  flatpak.enable=true;
  tlp={
    enable=true;
    settings={
      START_CHARGE_THRESH_BAT1=40;
      STOP_CHARGE_THRESH_BAT1=75;
    };
  };
}//
import ./login.nix {inherit pkgs;}//
import ./audio.nix {}//
import ./postgres.nix {inherit pkgs;}

