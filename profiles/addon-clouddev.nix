{
  pkgs,
  config,
  inputs,
  ...
}:

# these are dev tools that we want available
# system wide on my dev machine(s)

{
  config = {
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 7777 ];
    environment.systemPackages = [
      # (pkgs.writeShellScriptBin "start-openvscode-server" ''
      #   set -x
      #   port="$1"
      #   "${pkgs.openvscode-server}/bin/openvscode-server" --without-connection-token --accept-server-license-terms --host=0.0.0.0 --port=7777
      # '')
    ];
    services = {
      openvscode-server = {
        enable = true;
        user = "cole";
        group = "cole";
        host = "0.0.0.0"; # firewall protects us, we only allow in tailscale0
        withoutConnectionToken = true;
        telemetryLevel = "off";
        port = 7777;
        # extraEnvironment = {
        #   NIX_PATH = "nixpkgs=/home/cole/code/nixpkgs/cmpkgs";
        # };
      };
    };
  };
}
