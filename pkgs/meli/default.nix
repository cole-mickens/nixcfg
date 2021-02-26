{ stdenv
, lib
, fetchgit
, rustPlatform
, pkgconfig
, openssl
, dbus
, sqlite
, file
, gzip
, makeWrapper
, notmuch
  # Build with support for notmuch backend
, withNotmuch ? true
}:

let metadata = import ./metadata.nix; in
rustPlatform.buildRustPackage rec {
  pname = "meli";
  version = metadata.rev;

  src = fetchgit {
    url = "https://git.meli.delivery/meli/meli.git";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  cargoSha256 = metadata.cargoSha256;

  cargoBuildFlags = lib.optional withNotmuch "--features=notmuch";

  nativeBuildInputs = [ pkgconfig gzip makeWrapper ];

  buildInputs = [ openssl dbus sqlite ] ++ lib.optional withNotmuch notmuch;

  checkInputs = [ file ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    gzip < docs/meli.1 > $out/share/man/man1/meli.1.gz
    mkdir -p $out/share/man/man5
    gzip < docs/meli.conf.5 > $out/share/man/man5/meli.conf.5.gz
    gzip < docs/meli-themes.5 > $out/share/man/man5/meli-themes.5.gz
  '' + lib.optionalString withNotmuch ''
    # Fixes this runtime error when meli is started with notmuch configured:
    # $ meli
    # libnotmuch5 was not found in your system. Make sure it is installed and
    # in the library paths.
    # notmuch is not a valid mail backend
    wrapProgram $out/bin/meli --set LD_LIBRARY_PATH ${notmuch}/lib
  '';

  meta = with stdenv.lib; {
    description = "Experimental terminal mail client aiming for configurability and extensibility with sane defaults";
    homepage = "https://meli.delivery";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F matthiasbeyer erictapen ];
    platforms = [ "x86_64-linux" ]; # meli is broken on aarch64 right now
  };
}
