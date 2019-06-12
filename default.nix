{pkgs ? import <nixpkgs> {}}:
let
  fetcher = { owner, repo, rev, sha256 }: builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
  };
  versions = builtins.mapAttrs
    (_: fetcher)
    (builtins.fromJSON (builtins.readFile ./versions.json));
  pkgs = import versions.nixpkgs {};
  padelude = pkgs.haskellPackages.mkDerivation {
    pname = "padelude";
    version = "2018-01-12";
    license = "GPLv3";

    src = pkgs.fetchFromGitHub {
      owner = "qfjp";
      repo = "padelude";
      rev = "c549b22ef4f2883d43dd3828910136c8147ff51c";
      sha256 = "0n7xjbb0s722rk0y7knj7vq1qv7zglz4rpx7qxzplwzbn4lff96s";
    };

    buildDepends = [
      pkgs.haskellPackages.protolude
      pkgs.haskellPackages.set-monad
    ];
  };
in pkgs.haskellPackages.mkDerivation {
  pname = "template-nix";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = with pkgs.haskellPackages; [ base padelude ];
  executableHaskellDepends = with pkgs.haskellPackages; [ base padelude ];
  executableSystemDepends = [];
  homepage = "https://github.com/qfjp/template";
  description = "A short description of the template";
  license = with pkgs; stdenv.lib.licenses.gpl3;
}
