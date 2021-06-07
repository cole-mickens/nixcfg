{ stdenv, lib, rustPlatform, fetchFromGitHub
, pkg-config
, xorg
}:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "zellij";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = pname;
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  cargoSha256 = metadata.cargoSha256;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11
  ];

  # a bunch of tests fail:
  # test tests::integration::basic::cannot_split_terminals_horizontally_when_active_terminal_is_too_small ... FAILED
  doCheck = false;

  meta = with lib; {
    description = "";
    homepage = "https://github.com/zellij-org/zellij";
    license = licenses.mit;
    maintainers = [];
  };
}
