{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings   #-}

module Main (main) where

import           Control.Monad.IO.Class (liftIO)
import           Data.IORef             (newIORef, readIORef, modifyIORef)
import           Data.List              (find)
import           Models
import           Network.HTTP.Types     (status404)
import           Web.Scotty             (scotty, get, captureParam, post, jsonData, json, raiseStatus)

-- Sample product list
initialProducts :: [Product]
initialProducts =
  [ Product 1 "Product 1" "Description 1" 19.99
  , Product 2 "Product 2" "Description 2" 29.99
  ]

main :: IO ()
main = do
  -- Create a mutable reference to store the products
  productsRef <- newIORef initialProducts
  scotty 3000 $ do
    -- Define a route to list all products
    get "/products" $ do
      products <- liftIO $ readIORef productsRef
      json products

    -- Define a route to get a product by ID
    get "/products/:id" $ do
      productIdParam <- captureParam "id"
      products <- liftIO $ readIORef productsRef
      let prod = findProductById productIdParam products
      case prod of
        Just p  -> json p
        Nothing -> raiseStatus status404 "not found"

    -- Define a route to create a new product
    post "/products" $ do
      newProduct <- jsonData
      liftIO $ modifyIORef productsRef (newProduct :)
      json newProduct

-- Function to find a product by ID in a list of products
-- using the OverloadedRecordDot extension allows to use prod.id without
-- having to disambiguate the field name 'id' which is shared with the User type
-- Using this syntax also avoids a clash with the Prelude.id function
findProductById :: Int -> [Product] -> Maybe Product
findProductById idx = find (\prod -> prod.id == idx)
