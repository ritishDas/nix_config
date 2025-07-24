{ pkgs,inputs }:
{
    variables = {
        PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
        PRISMA_QUERY_ENGINE_BINARY  = "${pkgs.prisma-engines}/bin/query-engine";
        PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
        PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
        PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
        NIXOS_OZONE_WL = "1";
        ANDROID_HOME = "/home/ritish/.androidStudio/sdk";
        JAVA_HOME = "${pkgs.jdk24}/lib/openjdk";
        PATH = [ "$PATH:$ANDROID_HOME/platform-tools" ];
        EDITOR = "vim";
        XCURSOR_SIZE="40";
        HYPRCURSOR_SIZE="40";
        HYPRCURSOR_THEME="rose-pine-hyprcursor";
        QT_QPA_PLATFORMTHEME="qt6ct";
        QT_QPA_PLATFORM="wayland";
        GDK_BACKEND="wayland";
        SDL_VIDEODRIVER="wayland";
        CLUTTER_BACKEND="wayland";
        XDG_CURRENT_DESKTOP="Hyprland";
        XDG_SESSION_TYPE="wayland";
        XDG_SESSION_DESKTOP="Hyprland";
        MOZ_ENABLE_WAYLAND = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    systemPackages = (import ../programs){inherit pkgs;inherit inputs;};
    shellAliases = {
        rb = "cd /etc/nixos;sudo nixos-rebuild switch --flake .#nixos;hyprctl reload";
        ed = "sudo vim /etc/nixos";
    };

}
