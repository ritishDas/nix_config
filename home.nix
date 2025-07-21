{ config, pkgs, lib ,... }:

{
  home.username = "ritish";
  home.homeDirectory = "/home/ritish";
  home.stateVersion = "25.05"; # Match your NixOS version

      home.sessionVariables = {
          EDITOR = "nvim";
          NIXPKGS_ALLOW_UNFREE = "1";
      };



  home.activation.copyConfigs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.config

    copy_and_fix() {
      local src=$1
      local dest=$2

      rm -rf "$dest"
      cp -r "$src" "$dest"

      # Fix permissions to ensure writability
      find "$dest" -type d -exec chmod u+rwx {} +
      find "$dest" -type f -exec chmod u+rw {} +
    }

    copy_and_fix ${./configs/dunst} $HOME/.config/dunst
    copy_and_fix ${./configs/gammastep} $HOME/.config/gammastep
    copy_and_fix ${./configs/tofi} $HOME/.config/tofi
    copy_and_fix ${./configs/waybar} $HOME/.config/waybar
    copy_and_fix ${./configs/hypr} $HOME/.config/hypr
  '';

home.file.".local/share/applications/nvim.desktop".text = ''
  [Desktop Entry]
  Name=Neovim
  Comment=Edit text files
  Exec=alacritty -e nvim
  Terminal=false
  Type=Application
  Icon=nvim
  Categories=Utility;TextEditor;
'';

home.file.".local/share/applications/open-terminal-here.desktop".text = ''
[Desktop Entry]
Name=Open Terminal Here (Alacritty)
Exec=alacritty --working-directory %f
Type=Application
Terminal=false
NoDisplay=false
MimeType=inode/directory;
'';

}

