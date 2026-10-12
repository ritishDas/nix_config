{pkgs}:
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
  upower.enable=true;
  tlp={
    enable=true;
    settings={
      START_CHARGE_THRESH_BAT1=40;
      STOP_CHARGE_THRESH_BAT1=75;
    };
  };



blueman.enable = true;

}//
import ./login.nix {inherit pkgs;}//
import ./audio.nix {}//
import ./database.nix {inherit pkgs;}

  # flatpak.enable=true;
  # k3s={
  # enable=true;
  # role="server";
  # };
  #
  # speechd = {
  #   enable = true;
  # };
