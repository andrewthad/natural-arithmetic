{-# language DataKinds #-}
{-# language DerivingStrategies #-}
{-# language ExplicitNamespaces #-}
{-# language GADTSyntax #-}
{-# language GeneralizedNewtypeDeriving #-}
{-# language KindSignatures #-}
{-# language RoleAnnotations #-}
{-# language StandaloneDeriving #-}
{-# language TypeOperators #-}

module Arithmetic.Unsafe
  ( Nat(..)
  , type (<)(Lt)
  , type (<=)(Lte)
  , type (:=:)(Eq)
  ) where

import Prelude hiding ((>=),(<=))

import Control.Category (Category)
import Data.Kind (Type)

import qualified Control.Category
import qualified GHC.TypeNats as GHC

-- Do not import this module unless you enjoy pain.
-- Using this library to implement length-indexed arrays
-- or sized builders does not require importing this
-- module to get the value out of the Nat data constructor.
-- Use Arithmetic.Nat.demote for this purpose.

infix 4 <
infix 4 <=
infix 4 :=:

-- | A value-level representation of a natural number @n@.
newtype Nat (n :: GHC.Nat) = Nat { getNat :: Int }
type role Nat nominal

deriving newtype instance Show (Nat n)

-- | Proof that the first argument is strictly less than the
-- second argument.
data (<) :: GHC.Nat -> GHC.Nat -> Type where
  Lt :: a < b

-- | Proof that the first argument is less than or equal to the
-- second argument.
data (<=) :: GHC.Nat -> GHC.Nat -> Type where
  Lte :: a <= b

-- | Proof that the first argument is equal to the second argument.
data (:=:) :: GHC.Nat -> GHC.Nat -> Type where
  Eq :: a :=: b

instance Category (<=) where
  id = Lte
  Lte . Lte = Lte

instance Category (:=:) where
  id = Eq
  Eq . Eq = Eq
