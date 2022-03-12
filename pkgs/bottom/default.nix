args_@{ lib
, fetchFromGitHub
, bottom
# , qqc2-desktop-style, sonnet, kio
# , extra-cmake-modules, pkg-config
, ... }:

let
  metadata = rec {
    repo_git = "https://github.com/ClementTsang/bottom";
    branch = "master";
    rev = "f2b8b4e8427996407b484c4a4ed9432519c9d3a5";
    sha256 = "sha256-bJ1zqfiiIW6A3nV8zYWHYbEoGeWSW5wlk/n0EItf4C0=";
    cargoSha256 = "sha256-bJ1zqfiiIW6A3nV8zYWHYbEoGeWSW5wlk/n0EItf4C0=";
    version = rev;
  };
  extraNativeBuildInputs = [
    # "extra-cmake-modules" "pkg-config"
  ];
  extraBuildInputs = [
    # "qqc2-desktop-style" "sonnet" "kio"
  ];
  ignore = [ "bottom" "fetchFromGithub" "runCommandNoCC" ] ++ extraBuildInputs;
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
  newsrc = bottom.src.overrideAttrs(old: {
    inherit (metadata) rev sha256;
  });
  cargo_new_version = builtins.substring 0 10 metadata.rev;
in
(bottom.override args).overrideAttrs(old: rec {
  pname = "bottom";
  version = cargo_new_version;
  src = newsrc;

  cargoDeps = old.cargoDeps.overrideAttrs (lib.const {
    src = newsrc;
    name = "${pname}-${cargo_new_version}-vendor.tar.gz";
    outputHash = metadata.cargoSha256;
  });

  buildInputs = old.buildInputs ++ (map (n: args_.${n}) extraBuildInputs);
  nativeBuildInputs = old.nativeBuildInputs ++ (map (n: args_.${n}) extraNativeBuildInputs);

  meta = (old.meta or {}) // { description = "${old.description or pname}"; verinfo = metadata; };
})
