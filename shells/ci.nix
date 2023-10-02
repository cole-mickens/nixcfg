{ pkgs, inputs, ... }:

let
  minimalMkShell = import ./_minimal.nix { inherit pkgs; };
in
minimalMkShell {
  name = "shell-ci";

  # shellHook = ''
  #   # activate secrets?
  # '';

  nativeBuildInputs = (
    (with pkgs; [
      cachix
      cacert
      du-dust
      git
      # gh
      mercurial
      nushell
      openssh
      # sd
      # ripgrep
      nixpkgs-fmt
    ]) ++ [
      inputs.nix-eval-jobs.outputs.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.nix-update.outputs.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.nix-fast-build.outputs.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
  );
}
