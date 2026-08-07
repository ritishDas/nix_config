{} : 
{
  hostName = "nixos";
  networkmanager={
    enable = true;
    wifi.backend = "wpa_supplicant";
  };
  # resolvconf.enable = false;
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


#   wg-quick.interfaces.wg0 = {
#   address = [ "10.10.37.36/32" ];
#
#   dns = [ "172.31.73.93" ];
#
#   privateKey = "cIGhnn6aS/7098H0CU9MN4PtOB9O/qj+sDy1rM6abkw=";
#
#   peers = [
#     {
#       publicKey = "MKJQByaju1m3tiGBHXmKl2St4Bjp61CnzRAZ1RWJaX0=";
#       endpoint = "13.203.29.71:51820";
#       allowedIPs = [ "0.0.0.0/0" ];
#       persistentKeepalive = 25;
#     }
#   ];
# };
}
