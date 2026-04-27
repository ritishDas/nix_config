{ config, pkgs, lib, ... }:

let
  configDir = ./configs;
  apps = [ "mpv" "assets" "wlogout" "dunst" "tofi" "waybar" "hypr" "nvim" ];
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



  # home.file.".local/share/applications/Neovim.desktop".text = ''
  #   [Desktop Entry]
  #   Name=Neovim
  #     Icon=${./icons/nvim.png}
  # Exec=alacritty -e sh -c 'nvim "%f"'
  #   Type=Application
  #   Terminal=false
  #   NoDisplay=false
  #   MimeType=inode/directory;
  # '';

  home.file.".local/share/applications/open-github.desktop".text = ''
    [Desktop Entry]
    Name=GitHub
      Exec=chromium --app=https://github.com
      Icon=github
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/open-gemini.desktop".text = ''
    [Desktop Entry]
    Name=Gemini
      Exec=chromium --app=https://gemini.google.com/
      Icon=youtube
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/open-claude.desktop".text = ''
    [Desktop Entry]
    Name=Claude
      Exec=chromium --app=https://claude.ai/new
      Icon=youtube
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/whatsapp.desktop".text = ''
    [Desktop Entry]
    Name=Whatsapp
      Exec=chromium --app=https://web.whatsapp.com/
      Icon=whatsapp
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/discord.desktop".text = ''
    [Desktop Entry]
    Name=Discord
      Exec=chromium --app=https://discord.com/app
      Icon=discord
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".bash_profile".text=''
    # ~/.bash_profile

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
  '';

  home.file.".bashrc".text = ''
    eval "$(direnv hook bash)"

gitac() {
  if [ -z "$1" ]; then
    echo "Error: No commit message provided."
    return 1
  fi

  git add .
  git commit -m "$*"
}


gitreset() {
  local remote="$1"
  local branch="$2"

  if [ -z "$1" ]; then
    echo "Error: No Remote Provided."
    return 1
  fi

  if [ -z "$2" ]; then
    echo "Error: No branch Provided."
    return 2
  fi

  echo "Resetting to $remote/$branch..."

  git fetch "$remote" &&
  git reset --hard "$remote/$branch" &&
  git clean -fd
}

  '';


  home.file.".local/share/applications/project.desktop".text = ''
  [Desktop Entry]
Exec=/home/ritish/project.sh
MimeType=application/pdf;
Name=Project
Terminal=false
Type=Application
  '';

  home.file.".wezterm.lua".text=''
  local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Basic Settings
config.default_prog = { "/run/current-system/sw/bin/bash", "-l" }
config.font_size = 12.0

-- UI Enhancements
config.color_scheme = 'Catppuccin Macchiato' -- A very popular, easy-on-the-eyes theme
config.hide_tab_bar_if_only_one_tab = true   -- Keeps it clean until you need tabs

-- Font Configuration
-- WezTerm comes with 'JetBrains Mono' bundled, which is excellent.
config.font = wezterm.font('JetBrains Mono')

config.window_close_confirmation = "NeverPrompt"
-- Window Frame / Padding
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

return config
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

