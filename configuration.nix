{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    useOSProber = true;
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [5000 6000];
    allowedUDPPorts = [6000];
  };

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.ritish = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" ];
  };

  security.sudo.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    xfce.xfce4-panel
    xfce.xfce4-settings
    xfce.xfce4-terminal
    xfce.thunar
    xfce.xfce4-power-manager
    xfce.xfce4-netload-plugin
    networkmanagerapplet
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    neofetch
    htop
    intel-gpu-tools
    redshift
    emote
    firefox
    neovim
    git
    pcsx2
    xclip
    whatsapp-for-linux
    unzip
    libreoffice-qt6-fresh
    typescript-language-server
    tailwindcss-language-server
    superhtml
    ccls
    vimPlugins.vim-prisma
    gcc
    postman
    live-server
    obs-studio
    chromium
    localsend
    openssl
    godot_4
    prisma-engines
    steam-run
    postgresql
    nodejs_23
    docker_28
  ];


  environment.sessionVariables = {
  PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
  PRISMA_QUERY_ENGINE_BINARY  = "${pkgs.prisma-engines}/bin/query-engine";
  PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
  PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
  PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
};

  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  services.libinput.enable = true;

  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    displayManager.lightdm.enable = true;
    videoDrivers = [ "modesetting" ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libvdpau-va-gl
    ];
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };

  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_28;
  };

  system.stateVersion = "24.05";
}
