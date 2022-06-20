{-# LANGUAGE OverloadedStrings #-}

module Main where
import Routes.Get (getAllCharacters, getAllCharacters_, getCharacterWithId)
import Web.Scotty (get, json, param, ScottyM, scotty)
import Data.Aeson (ToJSON, FromJSON, encode)
import DB.DB(connectToDb, allCharacters, characterSelect, selectCharacterByName_, selectCharacterById_, insertCharacter_, deleteCharacterWithName_)

{-
main :: IO ()
main = do
  putStrLn "Starting server ..."
  scotty 3000 $ do
    
   getAllCharacters 
   getCharacterWithId 
   getCharacterWithName
-}

main :: IO ()
main = do
  putStrLn "Connecting to database ..."

  db <- connectToDb
  -- insert <- insertCharacter_ db (0, "Sol", "https://www.dustloop.com/wiki/images/thumb/0/04/GGST_Sol_Badguy_Portrait.png/318px-GGST_Sol_Badguy_Portrait.png", 0.98, 2, "normal")
  -- delete <- deleteCharacterWithName_ db "Sol"
  
  putStrLn "Starting server ..."

  scotty 3000 $ do
  -- Create Database connection

    allCharacter <- getAllCharacters_ db
    characterById <- getCharacterWithId db 0

    return ()