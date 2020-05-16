{-# OPTIONS_GHC -fno-warn-redundant-constraints #-}
{-# OPTIONS_GHC -fno-warn-unused-top-binds #-}
{-# OPTIONS_HADDOCK hide #-}

{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE KindSignatures        #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE StandaloneDeriving    #-}
{-# LANGUAGE TemplateHaskell       #-}

-- |
-- Module      : Data.Type.Predicate.TH.Example
-- License     : BSD3
-- Copyright   : (c) Evgeny Poberezkin 2020
--
-- Maintainer  : evgeny@poberezkin.com
-- Stability   : experimental
-- Portability : non-portable
--
-- Example & test of using 'instances' template to generate instances
-- of Auto typeclass for parametrized type constructor.
module Data.Type.Predicate.TH.Test () where

import Data.Type.Predicate
import Data.Type.Predicate.Auto
import Data.Type.Predicate.TH

data P = A | B | C
  deriving (Show)

data T (a :: P) where
  TA :: T 'A
  TB :: T 'B
  TC :: T 'C

deriving instance Show (T a)

$(autoI [d|
  data T1 (a :: P) where
    T1A :: T1 'A
    T1B :: T1 'B
  |])

f :: Auto (TyPred T1) p => T p -> String
f = show

-- |
-- The compiler warns that the constraint is redundant (it's disabled with pragma on top),
-- but it is taken into account:
--
-- >>> f TA
-- "TA"
-- >>> f TB
-- "TB"
-- >>> f TC
-- ...
-- ... No instance for (Auto (TyPred T1) 'C) arising from a use of ‘f’
-- ... In the expression: f TC
-- ...
