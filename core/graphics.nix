{pkgs}:
{
    graphics = {
        enable = true;
        extraPackages = with pkgs; [
            intel-vaapi-driver
                vaapiVdpau
                intel-compute-runtime-legacy1
                        intel-ocl
                libvdpau-va-gl
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
            libvdpau-va-gl
        ];
    };
}
