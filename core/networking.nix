{} : 
{
  hostName = "nixos";
  networkmanager={
    enable = true;
    wifi.backend = "wpa_supplicant";
  };
  resolvconf.enable = false;
  nameservers =[
    "1.1.1.1"
    "1.0.0.1"
  ];
  firewall = {
    enable = true;
    trustedInterfaces=["wlp3s0"];
    # allowedTCPPorts = [ 5000 6000 ];
  };
  nat.enable=true;
}
