module Data.Constructors.EqC (EqC(..)) where

class EqC a where eqConstr :: a -> a -> Bool
