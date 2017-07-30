{-# language TemplateHaskell #-}
{-# language DeriveDataTypeable #-}
{-# language DeriveGeneric #-}
module Main where
import Data.Constructors.TH
import Data.Function (on)
import Data.Data (Data,toConstr)
import Test.QuickCheck (Arbitrary(..),sample,quickCheck)
import Test.QuickCheck.Gen (Gen,oneof)

data PhpValue = VoidValue | IntValue Integer | BoolValue Bool deriving (Data,Show)
$(deriveEqC ''PhpValue)
instance Arbitrary PhpValue where
  arbitrary = oneof [pure VoidValue, IntValue <$> arbitrary, BoolValue <$> arbitrary]

eqConstrDefault :: Data a => a -> a -> Bool
eqConstrDefault = (==) `on` toConstr

prop_EqC :: PhpValue -> PhpValue -> Bool
prop_EqC x y = eqConstrDefault x y == eqConstr x y

main = quickCheck prop_EqC
