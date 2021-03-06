{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}
module Language.Elm.Name where

import Protolude

import Data.String
import qualified Data.Char as Char
import qualified Data.Text as Text

type Module = [Text]

newtype Local = Local Text
  deriving stock (Eq, Ord, Show, Generic)
  deriving newtype IsString
  deriving anyclass (Hashable)

data Qualified = Qualified Module Text
  deriving (Eq, Ord, Show, Generic, Hashable)

isConstructor :: Qualified -> Bool
isConstructor name =
  case name of
    "List.::" ->
      True

    "Basics.," ->
      True

    "Basics.()" ->
      True

    Qualified _ (Text.uncons -> Just (firstChar, _)) ->
      Char.isUpper firstChar

    _ ->
      False

instance IsString Qualified where
  fromString s =
    case unsnoc $ Text.splitOn "." $ fromString s of
      Nothing ->
        panic "Empty name"

      Just ([], x) ->
        panic $ "Unqualified name " <> show x

      Just (xs, x) ->
        Qualified xs x

newtype Field = Field Text
  deriving stock (Eq, Ord, Show, Generic)
  deriving newtype IsString
  deriving anyclass (Hashable)

newtype Constructor = Constructor Text
  deriving stock (Eq, Ord, Show, Generic)
  deriving newtype IsString
  deriving anyclass (Hashable)
