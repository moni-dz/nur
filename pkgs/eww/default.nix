{ lib, pkgs }:

with pkgs;

let
  moz-overlay = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "8c007b60731c07dd7a052cce508de3bb1ae849b4";
    sha256 = "sha256-RsNPnEKd7BcogwkqhaV5kI/HuNC4flH/OQCC/4W5y/8=";
  };

  mozilla = callPackage "${moz-overlay.out}/package-set.nix" { };

  nightly-rust = (mozilla.rustChannelOf { channel = "nightly"; date = "2021-03-01"; }).rust;
in
(makeRustPlatform { cargo = nightly-rust; rustc = nightly-rust; }).buildRustPackage rec {
  pname = "eww";
  version = "unstable-2021-02-27";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = pname;
    rev = "a18901f187ff850a21a24c0c59022c0a5382ffd9";
    sha256 = "sha256-iHHXv1R9X5is0A5GwMFSHEdi043Ad9FdFUQ4YtZ3w+s=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk3
    cairo
    glib
    atk
    pango
    gdk-pixbuf
    gdk-pixbuf-xlib
  ];

  checkPhase = null;
  cargoSha256 = "sha256-VrA/t+qPuREFULaKFnXzCCyAul/OXLX791ZL+D0PBSY=";

  meta = with lib; {
    description =
      "A standalone widget system made in Rust to add AwesomeWM like widgets to any WM";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
