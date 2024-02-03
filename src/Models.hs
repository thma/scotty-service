{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE DuplicateRecordFields #-}

module Models (Product (..), User (..)) where

import           Data.Aeson
import           Data.Text
import           GHC.Generics

-- Define a Product data type
data Product = Product
  { id          :: Int,
    name        :: Text,
    description :: Text,
    price       :: Double
  }
  deriving (Show, Generic, ToJSON, FromJSON)

-- Define a User data type, which uses same attribute names as Product
-- This is made possible by the DuplicateRecordFields extension
data User = User
  { id          :: Int,
    name        :: Text,
    description :: Text
  }
  deriving (Show, Generic, ToJSON, FromJSON)
