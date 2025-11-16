{pkgs}:
{
  graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        intel-compute-runtime-legacy1
        intel-ocl
        libvdpau-va-gl

    ];
  };


}


