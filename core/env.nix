{ pkgs,inputs,lib }:
{
  variables = {
    NIXOS_OZONE_WL = "1";
    PATH = [ "$PATH:$ANDROID_HOME/platform-tools" ];
    EDITOR = "nvim";
    XCURSOR_SIZE="40";
    HYPRCURSOR_SIZE="40";
    HYPRCURSOR_THEME="rose-pine-hyprcursor";
    QT_QPA_PLATFORMTHEME="qt6ct";
    QT_QPA_PLATFORM="wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
    QT_AUTO_SCREEN_SCALE_FACTOR="1";
    GDK_BACKEND="wayland";
    SDL_VIDEODRIVER="wayland";
    CLUTTER_BACKEND="wayland";
    XDG_CURRENT_DESKTOP="Hyprland";
    XDG_SESSION_TYPE="wayland";

    GSETTINGS_SCHEMA_DIR =
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}";
    #
    # XDG_DATA_DIRS =
    #   lib.mkForce (lib.concatStringsSep ":" [
    #     "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    #     "${pkgs.glib}/share"
    #     "$XDG_DATA_DIRS"
    #   ]);
    #
    XDG_SESSION_DESKTOP="Hyprland";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE="1";
    PNPM_HOME="/home/ritish/.local/share/pnpm/global/";

    VK_ICD_FILENAMES = lib.concatStringsSep ":" [
      "${pkgs.mesa}/share/vulkan/icd.d/intel_icd.x86_64.json"
      "${pkgs.mesa}/share/vulkan/icd.d/intel_hasvk_icd.x86_64.json"
    ];


  };
  systemPackages = (import ../programs){inherit pkgs;inherit inputs;};
  shellAliases = {
    rb = "cd /etc/nixos;sudo nixos-rebuild switch --flake .#nixos;hyprctl reload";
    ed = "cd /etc/nixos ; sudo nvim configuration.nix";
    sz = "du -sh .[^.]* */ | sort -h";
    reporeset = "git fetch origin & git reset --hard origin/main & git clean -fd";
  };


}

  #   PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
  #   PRISMA_QUERY_ENGINE_BINARY  = "${pkgs.prisma-engines}/bin/query-engine";
  #   PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
  #   PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
  #   PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
