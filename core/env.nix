{ pkgs }:
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
  };
  systemPackages = (import ../programs){inherit pkgs;};
  shellAliases = {
    rb = "cd /etc/nixos && sudo nixos-rebuild switch --flake .#nixos";
    ed = "sudo nvim /etc/nixos/configuration.nix";
  };

}
