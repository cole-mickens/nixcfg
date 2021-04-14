# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [
    "hv_vmbus"
    #"hv_storsvc"
    "hyperv_keyboard"
    "hid_hyperv"

    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/922d29e8-08af-4a8f-88d7-ad8aff978d4c";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/a1f97902-a36f-4523-a119-fbefb2ad9638";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/879F-1940";
      fsType = "vfat";
    };

  swapDevices = [ ];

  virtualisation.hypervGuest.enable = true;
}
