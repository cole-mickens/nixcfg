{ lib
, fetchFromGitHub
, rustPlatform
, nixosTests
, nix-update-script
, autoPatchelfHook
, cmake
, ncurses
, pkg-config
, gcc-unwrapped
, fontconfig
, libGL
, vulkan-loader
, libxkbcommon
, withX11 ? true
, libX11
, libXcursor
, libXi
, libXrandr
, libxcb
, withWayland ? true
, wayland
,
}:
let
  rlinkLibs =
    [
      (lib.getLib gcc-unwrapped)
      fontconfig
      libGL
      libxkbcommon
      vulkan-loader
    ]
    ++ lib.optionals withX11 [
      libX11
      libXcursor
      libXi
      libXrandr
      libxcb
    ]
    ++ lib.optionals withWayland [ wayland ];
in
rustPlatform.buildRustPackage rec {
  pname = "rio";
  version = "nightly-unstable-2024-05-19";

  src = fetchFromGitHub {
    owner = "raphamorim";
    repo = "rio";
    rev = "47e8131937c0bea7ae804d9687ff4fb85dedfd20";
    hash = "sha256-9vFL+n/ghFfJozhD5OcYH5d8bzc8hOIdksPljLs0DtA=";
  };

  # cargoHash = "sha256-jev4fMwCygVzvrkI1nSE5tx59nGqNKQUHCNHvkr9R90=";
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  cargoBuildFlags = [
    "-p"
    "rioterm"
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    ncurses
    pkg-config
  ];

  runtimeDependencies = rlinkLibs;

  buildInputs = rlinkLibs;

  outputs = [
    "out"
    "terminfo"
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    (lib.optionalString withX11 "x11")
    (lib.optionalString withWayland "wayland")
  ];

  checkFlags = [
    # Fail to run in sandbox environment.
    "--skip=screen::context::test"
  ];

  postInstall = ''
    # install -D rio/src/screen/window/resources/images/logo.png $out/share/icons/hicolor/scalable/apps/rio.png
    install -D misc/rio.desktop -t $out/share/applications/

    install -dm 755 "$terminfo/share/terminfo/r/"
    tic -xe rio,rio-direct -o "$terminfo/share/terminfo" misc/rio.terminfo
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v([0-9.]+)"
      ];
    };

    tests.test = nixosTests.terminal-emulators.rio;
  };

  meta = {
    description = "A hardware-accelerated GPU terminal emulator powered by WebGPU";
    homepage = "https://raphamorim.io/rio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      otavio
      oluceps
    ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/raphamorim/rio/blob/v${version}/CHANGELOG.md";
  };
}
