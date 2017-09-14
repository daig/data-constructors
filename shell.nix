{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", withBenchmarkDepends ? true}:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, criterion, deepseq, QuickCheck, stdenv
      , template-haskell
      }:
      mkDerivation {
        pname = "data-constructors";
        version = "0.1.0.0";
        src = ./.;
        libraryHaskellDepends = [ base template-haskell ];
        testHaskellDepends = [ base QuickCheck ];
        benchmarkHaskellDepends = [ base criterion deepseq QuickCheck ];
        inherit withBenchmarkDepends;
        homepage = "https://github.com/daig/data-constructors#readme";
        description = "Generically compare data by their constructors";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
