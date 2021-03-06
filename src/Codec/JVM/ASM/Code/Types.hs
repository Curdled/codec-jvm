{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Codec.JVM.ASM.Code.Types where

import Codec.JVM.ASM.Code.CtrlFlow (CtrlFlow)

import Data.IntMap.Strict (IntMap)
import qualified Data.IntMap.Strict as IntMap

newtype Offset = Offset Int -- absolute
  deriving (Num, Show)

newtype StackMapTable = StackMapTable (IntMap CtrlFlow)
  deriving (Show)

-- Right-biased union
union' :: IntMap a -> IntMap a -> IntMap a
union' = IntMap.unionWith (flip const)

-- TODO: Implement a strict fold for mconcat
instance Monoid StackMapTable where
  mempty = StackMapTable mempty
  mappend (StackMapTable x) (StackMapTable y)
    = StackMapTable $ union' x y

newtype LabelTable = LabelTable { unLabelTable :: IntMap Offset }
  deriving Monoid

labelTableUnions :: [LabelTable] -> LabelTable
labelTableUnions = LabelTable
                 . IntMap.unions
                 . map unLabelTable
