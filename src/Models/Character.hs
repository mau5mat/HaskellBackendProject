{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module Models.Character where
import GHC.Generics
import Data.Monoid
import Data.Text (Text)
import Data.Aeson

data Character_ = Character_ 
  { cId :: Int 
  , cName :: Text
  , image :: Text
  , defense :: Double
  , guts :: Int
  , weight :: Text
  } deriving (Show, Generic)

instance ToJSON Character_ where
     toJSON (Character_ cId cName image defense guts weight) = 
       object 
       [ "cId" .= cId, 
         "cName" .= cName,
         "image" .= image,
         "defense" .= defense,
         "guts" .= guts,
         "weight" .= weight
       ]
instance FromJSON Character_


matchesId :: Int -> Character_ -> Bool 
matchesId id character = cId character == id

matchesName :: Text -> Character_ -> Bool 
matchesName name character = cName character == name


sol :: Character_
sol = Character_
  { cId = 0
  , cName = "Sol Badguy"
  , image = ""
  , defense = 0.98
  , guts = 2
  , weight = "normal"
  }

ky :: Character_
ky = Character_
  { cId = 1
  , cName = "Ky Kiske"
  , image = ""
  , defense = 1.0
  , guts = 2
  , weight = "normal"
  }

allCharacters :: [Character_]
allCharacters = [sol, ky]