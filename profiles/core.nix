{ pkgs, lib, config, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules."home-manager"

    ./user.nix
    ../mixins/common.nix

    ../mixins/git.nix
    ../mixins/ssh.nix
    ../mixins/zsh.nix

    ../mixins/helix.nix
    ../mixins/zellij.nix
  ];

  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.cole = { pkgs, ... }@hm: {
      home.extraOutputsToInstall = [ "info" "man" "share" "icons" "doc" ];
      home.stateVersion = "21.11";
      home.sessionVariables = {
        EDITOR = "hx";
        CARGO_HOME = "${hm.config.xdg.dataHome}/cargo";
        PARALLEL_HOME = "${hm.config.xdg.configHome}/parallel";
        PASSWORD_STORE_DIR = "${hm.config.xdg.dataHome}/password-store";
      };
      home.file = {
        "${hm.config.home.sessionVariables.PARALLEL_HOME}/will-cite".text = "";
        "${hm.config.home.sessionVariables.PARALLEL_HOME}/runs-without-willing-to-cite".text = "10";
      };
      manual = { manpages.enable = false; };
      news.display = "silent";
      programs = {
        home-manager.enable = true;
        gpg.enable = true;
      };
      home.packages = with pkgs; [
        bottom
      ];
    };
  };
}
