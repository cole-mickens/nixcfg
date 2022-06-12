{ config, pkgs, modulesPath, ... }:

{
  # imports = [
  #   ../secrets
  # ];
  
  config = {
    networking.wireless = {
      enable = true;
      userControlled.enable = true;
      iwd.enable = false;
      environmentFile = config.sops.secrets."wireless.env".path;
      networks = {
        # TODO: map these automatically
        "chimera-wifi".pskRaw = "@pskRaw_chimera_wifi@";
        "Mickey".pskRaw = "@pskRaw_Mickey@";
        "Pixcole3".pskRaw = "@pskRaw_Pixcole3@";
        "courtyardGuest".pskRaw = "@pskRaw_courtyardGuest@";
      };
    };
  };
}
