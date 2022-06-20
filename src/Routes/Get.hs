{-# LANGUAGE OverloadedStrings #-}

module Routes.Get where
import DB.DB (allCharacters, allCharacters_, selectCharacterById_)
import Control.Monad.IO.Class (liftIO)
import Database.PostgreSQL.Simple (Connection, connect, ConnectInfo(..))
import Models.Character (matchesId, matchesName)
import Web.Scotty (get, json, jsonData, param, ScottyM, liftAndCatchIO)
import GHC.Generics ()
import Data.Aeson (ToJSON, FromJSON)


getAllCharacters :: Connection -> ScottyM ()
getAllCharacters db = do
   get "/characters" $ do
      characters <- liftIO $ allCharacters db
      json characters

getAllCharacters_ :: Connection -> ScottyM ()
getAllCharacters_ db = do
   get "/characters" $ do
      characters <- liftAndCatchIO $ allCharacters_ db
      json characters

getCharacterWithId :: Connection -> Int -> ScottyM ()
getCharacterWithId db id = do
  get "/character/:id" $ do
    id <- param "id"
    character <- liftAndCatchIO $ selectCharacterById_ db id
    json character

{-
getCharacterWithId :: ScottyM ()
getCharacterWithId = do
  get "/character/:id" $ do
      id <- param "id"
      json $ filter (matchesId id) allCharacters

getCharacterWithName :: ScottyM ()
getCharacterWithName = do
  get "/character/:name" $ do
    name <- param "name"
    json $ filter (matchesName name) allCharacters
-}