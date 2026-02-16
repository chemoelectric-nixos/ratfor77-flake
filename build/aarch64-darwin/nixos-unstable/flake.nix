# Copyright © 2025, 2026dvm Barry Schwartz
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

{
  description = "A Nix flake for ratfor77";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      package-owner = "chemoelectric";
      package-name = "ratfor77";
      package-revision = "55448b9cc13e1b71e100063a97001800d7db790e";
      package-hash = "sha256-zXT04oMtN2fHlciZqh5QsGjU+94aqVDJn8DfPB6CPhA=";
      package-homepage = "https://sourceforge.net/p/${package-owner}/${package-name}/";
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      cc = "${pkgs.gcc}/bin/gcc";
      make = "${pkgs.gnumake}/bin/make";
      install = "${pkgs.coreutils}/bin/install";
    in
    {
      packages."aarch64-darwin" = rec {

        default = ratfor77;

        ratfor77 = pkgs.stdenv.mkDerivation (var: {

          name = package-name;

          src = pkgs.fetchhg {
            url = "http://hg.code.sf.net/p/${package-owner}/${package-name}";
            rev = "${package-revision}";
            hash = "${package-hash}";
          };

          nativeBuildInputs = [
            pkgs.coreutils
            pkgs.gcc
            pkgs.gnumake
          ];

          configurePhase = ''
            :
          '';

          buildPhase = ''
            ${make} CC="${cc} -std=gnu89"
          '';

          installPhase = ''
            ${install} -d -m 755 $out/bin
            ${install} -m 755 ratfor77 $out/bin

            ${install} -d -m 755 $out/share
            ${install} -d -m 755 $out/share/doc
            ${install} -m 644 ratfor.man $out/share/doc
          '';

          meta = {
            homepage = "${package-homepage}";
            description = "A public domain Ratfor preprocessor";
            license = lib.licenses.publicDomain;
            mainProgram = package-name;
            platforms = lib.platforms.linux;
          };
        });
      };
    };
}
