{} : 
{
    hostName = "nixos";
    networkmanager={
        enable = true;
        wifi.backend = "wpa_supplicant";
    };
    firewall = {
        enable = true;
        allowedTCPPorts = [ 5000 6000 ];
    };
}
