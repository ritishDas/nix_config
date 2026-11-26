{ config, pkgs, lib,inputs, ... }:

let
configDir = ./configs;
user = "ritish";
apps = ["clangd" "eww" "mpv" "assets" "wlogout" "dunst" "tofi" "waybar" "hypr" "nvim" ];
in
{
  home.username = "ritish";
  home.homeDirectory = "/home/ritish";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = "1";
  };


  home.file.".local/share/fonts".source = ./fonts;





  home.file.".local/share/applications/element.desktop".text = ''
    [Desktop Entry]
    Name=X
      Exec=google-chrome --app=https://app.element.io/
      Icon=X
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/open-x.desktop".text = ''
    [Desktop Entry]
    Name=X
      Exec=google-chrome --app=https://x.com
      Icon=X
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/open-github.desktop".text = ''
    [Desktop Entry]
    Name=GitHub
      Exec=google-chrome --app=https://github.com
      Icon=github
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/open-gemini.desktop".text = ''
    [Desktop Entry]
    Name=Gemini
      Exec=google-chrome --app=https://gemini.google.com/
      Icon=youtube
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/open-gpt.desktop".text = ''
    [Desktop Entry]
    Name=ChatGPT
      Exec=google-chrome --app=https://chatgpt.com/
      Icon=youtube
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/whatsapp.desktop".text = ''
    [Desktop Entry]
    Name=Whatsapp
      Exec=google-chrome --app=https://web.whatsapp.com/
      Icon=whatsapp
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/discord.desktop".text = ''
    [Desktop Entry]
    Name=Discord
      Exec=google-chrome --app=https://discord.com/app
      Icon=discord
      Type=Application
      Categories=Network;WebBrowser;
  '';

  home.file.".bash_profile".text=''

    if [ -f ~/.bashrc ]; then
      . ~/.bashrc
        fi

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

    config.default_prog = { "/run/current-system/sw/bin/bash", "-l" }
  config.font_size = 12

    config.hide_tab_bar_if_only_one_tab = true   


    config.font = wezterm.font('0xProto Nerd FontMono' )

    config.font_rules = {
      {
        intensity = 'Bold',
        italic = false,
        font = wezterm.font('0xProto Nerd FontMono', {
            weight = 'Bold',
            }),
      },
      {
        italic = true,
        intensity = 'Normal',
        font = wezterm.font('0xProto Nerd FontMono', {
            style = 'Italic',
            }),
      },
      {
        italic = true,
        intensity = 'Bold',
        font = wezterm.font('0xProto Nerd FontMono', {
            weight = 'Bold',
            style = 'Italic',
            }),
      },
    }


  config.window_close_confirmation = "NeverPrompt"
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
        chown -R ${user}:users "$dest"
        chmod -R u+rwX "$dest"

    }


  ${lib.concatStringsSep "\n" (map (app: "update_config ${app}") apps)}
  '';

  home.file.".vimrc".text = ''
    syntax on
    filetype plugin indent on

    set number
    set relativenumber
    set hidden
    set splitright
    set splitbelow

    colorscheme quiet

    let mapleader = " "

    nnoremap <leader>s :w<CR>
    nnoremap <leader>e :bd!<CR>
    nnoremap <leader>h :bprevious<CR>
    nnoremap <leader>x :qa<CR>
    nnoremap <leader>f :Explore<CR>
    nnoremap <leader>vh :vsplit <bar> bprevious<CR>
    nnoremap <C-a> ggVG
    nnoremap <C-j> <C-d>zz
    nnoremap <C-k> <C-u>zz

    command! -nargs=0 R vsplit ~/.rough.md

    let s:term_bufnr = -1

    function! s:ToggleTerminal() abort
    if s:term_bufnr != -1 && bufexists(s:term_bufnr) && term_getstatus(s:term_bufnr) =~# 'running'
      let l:winid = bufwinid(s:term_bufnr)
        if l:winid != -1
          execute l:winid . 'wincmd c'
        else
          botright 10split
            execute 'buffer ' . s:term_bufnr
            endif
    else
      botright terminal ++rows=10
        let s:term_bufnr = bufnr('%')
        endif
        endfunction

        nnoremap <silent> <C-t> :call <SID>ToggleTerminal()<CR>
        tnoremap <silent> <C-t> <C-W>:call <SID>ToggleTerminal()<CR>
        tnoremap <Esc> <C-W>N
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

  hyprRefresh() { 
    cd ~/.config/hypr/; mv hypr/* . 
                                  }

                                  '';


                                  }

