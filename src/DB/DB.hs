{-# 
LANGUAGE Arrows,
FlexibleContexts, 
TemplateHaskell, 
FlexibleInstances, 
FlexibleContexts,
DeriveGeneric,
OverloadedStrings,
MultiParamTypeClasses 
#-}

module DB.DB where

import Opaleye

import Data.Profunctor.Product.TH (makeAdaptorAndInstance)
import Database.PostgreSQL.Simple (Connection, connect, ConnectInfo(..))
import Data.Profunctor.Product (p6)
import Control.Arrow (returnA)
import Data.Time (Day)
import Control.Monad (void)
import Data.Aeson
import Data.Text (Text)
import GHC.Int (Int64)

connectToDb :: IO Connection
connectToDb = connect ConnectInfo
    { connectHost = "localhost"
    , connectPort = 5432
    , connectDatabase = "ggst_db"
    , connectUser = "matthewroberts"
    , connectPassword = ""
    }

data Character' a b c d e f = Character
  { _id :: a
  , name :: b
  , image :: c
  , defense :: d
  , guts :: e
  , weight :: f
  } deriving (Show)

type Character = Character' Int Text Text Double Int Text

instance ToJSON Character where
     toJSON (Character a b c d e f) = 
       object 
       [ "_id" .= a, 
         "name" .= b,
         "image" .= c,
         "defense" .= d,
         "guts" .= e,
         "weight" .= f
       ]

type CharacterField = Character'
  (Field SqlInt4) 
  (Field SqlText) 
  (Field SqlText) 
  (Field SqlFloat8) 
  (Field SqlInt4) 
  (Field SqlText)

$(makeAdaptorAndInstance "pCharacter" ''Character')


characterTable_ :: Table CharacterField CharacterField
characterTable_ = table "characters"
                        (pCharacter Character 
                        { _id = tableField "_id"
                        , name = tableField "name"
                        , image = tableField "image"
                        , defense = tableField "defense"
                        , guts = tableField "guts"
                        , weight = tableField "weight"
                        })

characterTable :: Table 
  (Field SqlInt4, Field SqlText, Field SqlText, Field SqlFloat8, Field SqlInt4, Field SqlText)
  (Field SqlInt4, Field SqlText, Field SqlText, Field SqlFloat8, Field SqlInt4, Field SqlText)
characterTable = table "characters" 
  (p6 ( tableField "_id"
      , tableField "name"
      , tableField "image"
      , tableField "defense"
      , tableField "guts"
      , tableField "weight"
      ))


-- https://www.haskelltutorials.com/opaleye/instant-gratification.html

characterSelect :: Select (Field SqlInt4, Field SqlText, Field SqlText, Field SqlFloat8, Field SqlInt4, Field SqlText)
characterSelect = selectTable characterTable

characterSelect_ :: Select CharacterField
characterSelect_ = selectTable characterTable_

allCharacters :: Connection -> IO [(Int, Text, Text, Double, Int, Text)]
allCharacters connection = do
  runSelect connection $ selectTable characterTable

allCharacters_ :: Connection -> IO [Character]
allCharacters_ connection = do
  runSelect connection $ selectTable characterTable_

selectCharacterByName_ :: Connection -> Text -> IO [(Int, Text, Text, Double, Int, Text)]
selectCharacterByName_ connection name = do
  runSelect connection $ proc () -> do
    row@(_, x, _, _, _, _) <- selectTable characterTable -< ()
    restrict -< (x .== toFields name)
    returnA -< row

selectCharacterById_ :: Connection -> Int -> IO [(Int, Text, Text, Double, Int, Text)]
selectCharacterById_ connection id = do
  runSelect connection $ proc () -> do
    row@(x, _, _, _, _, _) <- characterSelect -< ()
    restrict -< (x .== toFields id)  
    returnA -< row

insertCharacter_ :: Connection -> Character -> IO ()
insertCharacter_ connection character = do
  void $ runInsert_ connection insert
  where insert = Insert
          { iTable = characterTable_
          , iRows = [(toFields character)]
          , iReturning = rCount
          , iOnConflict = Nothing
          }

updateCharacter_ :: Connection -> (Int, Text, Text, Double, Int, Text) -> IO ()
updateCharacter_ connection (a, b, c, d, e, f) = do
  void $ runUpdate_ connection update
    where update = Update
            { uTable = characterTable
            , uUpdateWith = (\(id_, _, _, _, _, _) -> (id_, toFields b, toFields c, toFields d, toFields e, toFields f))
            , uWhere = (\(id_, _, _, _, _, _) -> id_ .== toFields a)
            , uReturning = rCount
            }

deleteCharacter_ :: Connection -> (Int, Text, Text, Double, Int, Text) -> IO ()
deleteCharacter_ connection (a, b, c, d, e, f) = do
  void $ runDelete_ connection delete
    where delete = Delete
            { dTable = characterTable
            , dWhere = (\(id_, _, _, _, _, _) -> id_ .== toFields a)
            , dReturning = rCount
            }

deleteCharacterWithName_ :: Connection -> Text -> IO ()
deleteCharacterWithName_ connection name = do
  void $ runDelete_ connection delete
    where delete = Delete
            { dTable = characterTable
            , dWhere = \(_, x, _, _, _, _) -> x .== toFields name
            , dReturning = rCount
            }

-- Official Documentation https://github.com/tomjaguarpaw/haskell-opaleye/tree/master/Doc/Tutorial

selectCharacterByName :: Text -> Select (Field SqlText)
selectCharacterByName name = do
  row@(_, x, _, _, _, _) <- characterSelect
  where_ (x .== toFields name)
  pure x

insertCharacter :: (Int, Text, Text, Double, Int, Text) -> Insert Int64
insertCharacter character = Insert
  { iTable = characterTable
  , iRows = [(toFields character)]
  , iReturning = rCount
  , iOnConflict = Nothing
  }

deleteCharacterWithName :: Text -> Delete Int64
deleteCharacterWithName name = Delete
  { dTable = characterTable
  , dWhere = \(_, x, _, _, _, _) -> x .== toFields name
  , dReturning = rCount
  }

deleteCharacterWithId :: Int -> Delete Int64
deleteCharacterWithId id = Delete
  { dTable = characterTable
  , dWhere = \(x, _, _, _, _, _) -> x .== toFields id
  , dReturning = rCount
  }


