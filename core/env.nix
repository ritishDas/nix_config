{ pkgs,inputs,lib }:

let
hyprexpo-src = pkgs.fetchFromGitHub {
    owner = "sandwichfarm";
    repo = "hyprexpo";
    rev = "HEAD"; 
    sha256 = "sha256-DPht6eNnLPYzb2VLyonGRCTfrcpzcSmymQAzA3qpHK0=";
  };

  # hyprexpo-plugin = pkgs.callPackage "${hyprexpo-src}/default.nix" {
  #   hyprland = pkgs.hyprland; 
  # };
  
  hyprexpo-plugin = (pkgs.callPackage "${hyprexpo-src}/default.nix" {
  hyprland = pkgs.hyprland;
}).overrideAttrs (oldAttrs: {
  # Inject lua54 and its pkg-config setup into the build environment
  nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ 
    pkgs.pkg-config 
  ];
  
  buildInputs = (oldAttrs.buildInputs or []) ++ [ 
    pkgs.lua5_4
  ];
});

in
{
  variables = {
    NIXOS_OZONE_WL = "1";
    PATH = [ "$PATH:$ANDROID_HOME/platform-tools" ];
    EDITOR = "nvim";
    HYPR_PLUGIN_DIR = "${hyprexpo-plugin}";
    TEST="RD";

    XCURSOR_SIZE="40";
    HYPRCURSOR_SIZE="40";
    HYPRCURSOR_THEME="rose-pine-hyprcursor";
    QT_QPA_PLATFORMTHEME="qt6ct";
    NIXPKGS_ALLOW_UNFREE="1";
    QT_QPA_PLATFORM="wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
    QT_AUTO_SCREEN_SCALE_FACTOR="1";
    GDK_BACKEND="wayland";
    HYPRLAND_HEADERS = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/include";

    SDL_VIDEODRIVER="wayland";
    CLUTTER_BACKEND="wayland";
    XDG_CURRENT_DESKTOP="Hyprland";
    XDG_SESSION_TYPE="wayland";
    CHROME_EXECUTABLE="/run/current-system/sw/bin/chromium";

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
    vi = "nvim";
  };




}

  #   PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
  #   PRISMA_QUERY_ENGINE_BINARY  = "${pkgs.prisma-engines}/bin/query-engine";
  #   PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
  #   PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
  #   PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
