{-# language TemplateHaskell #-}
{-# language TypeApplications #-}
{-# language DeriveAnyClass #-}
{-# language DeriveDataTypeable #-}
{-# language DeriveGeneric #-}
module Main where
import Data.Constructors.TH
import Data.Function (on)
import Data.Data (Data,toConstr)
import GHC.Generics (Generic)
import Criterion
import Criterion.Main (defaultMain)
import Test.QuickCheck (Arbitrary(..),generate,vectorOf)
import Test.QuickCheck.Gen (Gen,oneof)
import Control.DeepSeq

data PhpValue = VoidValue | IntValue Integer | BoolValue Bool
  deriving (Generic,Data,Show,NFData)
$(deriveEqC ''PhpValue)
instance Arbitrary PhpValue where
  arbitrary = oneof [pure VoidValue, IntValue <$> arbitrary, BoolValue <$> arbitrary]

eqConstrDefault :: Data a => a -> a -> Bool
eqConstrDefault = (==) `on` toConstr

prop_EqC :: PhpValue -> PhpValue -> Bool
prop_EqC x y = eqConstrDefault x y == eqConstr x y

main = defaultMain [
  env setupEnv $ \ e ->
    bgroup "EqC"
      [bench "TH" $ whnf (\(a,b) -> eqConstr a b) e
      ,bench "Data" $ whnf (\(a,b) -> eqConstrDefault a b) e
      ]
  ]
  where
    setupEnv :: IO (PhpValue,PhpValue)
    setupEnv = generate $ (,) <$> arbitrary <*> arbitrary
