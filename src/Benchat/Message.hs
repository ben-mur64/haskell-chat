{-# LANGUAGE DeriveGeneric  #-}
module Benchat.Message where

import Data.Text (Text)
import GHC.Generics
import Data.Aeson

newtype ConnectMessage = ConnectMessage
  deriving (Show, Read, Eq, Ord, Generic)

instance ToJSON ConnectMessage
instance FromJSON ConnectMessage

data ChatMessage
  = SendChat Text
  | SlashMe Text
  deriving (Show, Read, Eq, Ord, Generic)

instance ToJSON ChatMessage
instance FromJSON ChatMessage

data NamedMessage = NamedMessage Text ChatMessage
  deriving (Show, Read, Eq, Ord, Generic)

instance ToJSON NamedMessage
instance FromJSON NamedMessage
