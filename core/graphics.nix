{pkgs}:
{
    graphics = {
        enable = true;
        extraPackages = with pkgs; [
            intel-media-driver
                vaapiVdpau
                intel-compute-runtime
                libvdpau-va-gl
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
            libvdpau-va-gl
        ];
    };
}
