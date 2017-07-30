module Data.Constructors.EqC (EqC(..)) where

class EqC a where
  -- | Compare the outermost constructor for a datatype.
  -- Instances should satisfy @eqConstr (C a) (K b) = True@ iff C=K
  eqConstr :: a -> a -> Bool
