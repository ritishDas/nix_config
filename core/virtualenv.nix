{pkgs}:
{
    docker = {
        enable = true;
        package = pkgs.docker_28;
    };
    libvirtd = {
        enable = true;
        qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = false;
        };
    };
}
