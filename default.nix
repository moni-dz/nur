{ pkgs ? import <nixpkgs> { } }:

{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  eww = pkgs.callPackage ./pkgs/eww { inherit pkgs; };

  ytmdl = pkgs.callPackage ./pkgs/ytmdl {
    bs4 = pkgs.callPackage ./pkgs/bs4 {
      python3Packages = pkgs.python3Packages;
    };
    simber = pkgs.callPackage ./pkgs/simber {
      python3Packages = pkgs.python3Packages;
    };
    pydes = pkgs.callPackage ./pkgs/pydes {
      python3Packages = pkgs.python3Packages;
    };
    downloader-cli = pkgs.callPackage ./pkgs/downloader-cli {
      fetchFromGitHub = pkgs.fetchFromGitHub;
      python3Packages = pkgs.python3Packages;
    };
    itunespy = pkgs.callPackage ./pkgs/itunespy {
      python3Packages = pkgs.python3Packages;
    };
    youtube-search = pkgs.callPackage ./pkgs/youtube-search {
      python3Packages = pkgs.python3Packages;
    };
    python3Packages = pkgs.python3Packages;
  };
}
