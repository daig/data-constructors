{-# LANGUAGE TemplateHaskell #-}
module Data.Constructors.TH (deriveEqC) where
import Data.Constructors.EqC

import Language.Haskell.TH as TH 
import Language.Haskell.TH.Syntax as TH

-- | Derive an instance of @EqC@ for any simple type
-- For example, @deriveEqC ''Either@ will generate:
--
-- > instance EqC (Either a b) where
-- >   eqConstr Left{}  Left{}  = True
-- >   eqConstr Right{} Right{} = True
-- >   eqConstr _       _       = False
deriveEqC :: Name -> DecsQ
deriveEqC n = do
  (saturatedType,constructors) <- extractTypeCons n
  return $ 
    [InstanceD
      Nothing
      []
      (AppT (ConT ''EqC) saturatedType)
      [FunD 'eqConstr constructors]]

extractTypeCons :: Name -> Q (TH.Type,[Clause])
extractTypeCons n = do
  true <- lift True
  false <- lift False
  reify n <&> \case
    TyConI (DataD _ _ tyVars _ cons _) ->
        (foldl (\c -> AppT c . extractTV) (ConT n) tyVars
        ,foldr (\c acc -> Clause [RecP c [], RecP c []] (NormalB true) [] : acc)
               [Clause [WildP,WildP] (NormalB false) []]
               (map (\(NormalC n _) -> n) cons))
    _ -> error "invalid name"

extractTV :: TyVarBndr -> TH.Type
extractTV = \case
  PlainTV n -> VarT n
  KindedTV n _ -> VarT n

(<&>) :: Functor f => f a -> (a -> b) -> f b
(<&>) = flip (<$>)
