{ pkgs, ... }:

{

bluetooth.enable = true;
graphics = {
  enable = true;
  enable32Bit = true;

  extraPackages = with pkgs; [
    intel-ocl
    # intel-compute-runtime 
    intel-compute-runtime-legacy1
    intel-media-driver  
    vpl-gpu-rt           
  ];

  # Optional: 32-bit acceleration/compute if running 32-bit games/emulators
  extraPackages32 = with pkgs.pkgsi686Linux; [
    intel-media-driver
  ];
};

}

