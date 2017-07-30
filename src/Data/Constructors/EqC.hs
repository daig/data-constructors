{-# language DefaultSignatures #-}
module Data.Constructors.EqC (EqC(..)) where
import Data.Function (on)
import Data.Data (Data,toConstr)

class EqC a where
  -- | Compare the outermost constructor for a datatype.
  -- Instances should satisfy @eqConstr (C a) (K b) = True@ iff C=K
  eqConstr :: a -> a -> Bool
  default eqConstr :: Data a => a -> a -> Bool
  eqConstr = on (==) toConstr
