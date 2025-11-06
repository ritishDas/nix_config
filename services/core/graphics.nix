{pkgs}:
{
  graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
        intel-media-driver
        intel-vaapi-driver
        vaapiVdpau
        intel-compute-runtime-legacy1
        intel-ocl
        libvdpau-va-gl

    ];
  };


}


