{ config, pkgs, lib, ... }:

let
  configDir = ./configs;
  apps = [ "mpv" "assets" "wlogout" "dunst" "gammastep" "tofi" "waybar" "hypr" "alacritty" "nvim" ];
in
  {
  home.username = "ritish";
  home.homeDirectory = "/home/ritish";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = "1";
  };


  home.file.".local/share/fonts".source = ./fonts;



  home.file.".local/share/applications/Neovim.desktop".text = ''
    [Desktop Entry]
    Name=Neovim
      Icon=${./icons/nvim.png}
  Exec=alacritty -e sh -c 'nvim "%f"'
    Type=Application
    Terminal=false
    NoDisplay=false
    MimeType=inode/directory;
  '';

  home.file.".local/share/applications/open-github.desktop".text = ''
    [Desktop Entry]
    Name=GitHub
      Exec=firefox https://github.com
      Icon=firefox
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/open-chatgpt.desktop".text = ''
    [Desktop Entry]
    Name=Chatgpt
      Exec=firefox https://chatgpt.com
      Icon=firefox
      Type=Application
      Categories=Network;WebBrowser;
  '';

  # home.file.".local/share/applications/whatsapp.desktop".text = ''
  #   [Desktop Entry]
  #   Name=Whatsapp
  #     Exec=chromium --app=https://web.whatsapp.com/
  #     Icon=whatsapp
  #     Type=Application
  #     Categories=Network;WebBrowser;
  # '';
  #
  # home.file.".local/share/applications/discord.desktop".text = ''
  #   [Desktop Entry]
  #   Name=Discord
  #     Exec=chromium --app=https://discord.com/app
  #     Icon=discord
  #     Type=Application
  #     Categories=Network;WebBrowser;
  # '';

  home.file.".bashrc".text = ''
    eval "$(direnv hook bash)"
  '';



  home.activation.updateConfigs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    update_config() {
      local name="$1"
        local src="${configDir}/$name"
        local dest="$HOME/.config/$name"

        rm -rf "$dest"
        cp -r "$src" "$dest"
        chown -R ritish:users "$dest"
        chmod -R u+rwX "$dest"
    }

    ${lib.concatStringsSep "\n" (map (app: "update_config ${app}") apps)}
  '';

}

