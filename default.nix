{ mkDerivation, base, criterion, deepseq, QuickCheck, stdenv
, template-haskell
}:
mkDerivation {
  pname = "data-constructors";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base template-haskell ];
  testHaskellDepends = [ base QuickCheck ];
  benchmarkHaskellDepends = [ base criterion deepseq QuickCheck ];
  homepage = "https://github.com/daig/data-constructors#readme";
  description = "Generically compare data by their constructors";
  license = stdenv.lib.licenses.bsd3;
}
