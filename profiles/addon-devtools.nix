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
    home-manager.users.cole =
      { pkgs, config, ... }@hm:
      {
        # programs.vscode = {
        #   enable = true;
        #   package = pkgs.vscodium.fhs;
        # };
        home = {
          packages = with pkgs; [
            alejandra
            nil
            nixpkgs-fmt

            # misc tools that I probably only need from primary dev machine:
            ventoy-full
          ];
          sessionVariables = {
            ENVRC_USE_FLAKE = 1;
          };
        };
      };
  };
}
