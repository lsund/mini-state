{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}

module IO.Repository (load, save) where

import           Control.Monad         (unless)
import           Data.Aeson            (FromJSON, ToJSON)
import qualified Data.Aeson            as Aeson
import qualified Data.ByteString.Char8 as Char8
import           Data.ByteString.Lazy  (toStrict)
import           Data.String           (fromString)
import           Data.Text             (Text)
import qualified Data.Text.Encoding    as TE
import           Data.Text.IO          (readFile, writeFile)
import qualified IO.Loader as L
import qualified  IO.Unloader as UL
import           Lens.Micro
import           Prelude               hiding (readFile, writeFile)
import           System.Directory      (createDirectoryIfMissing, doesFileExist)


basedir :: FilePath
basedir = "ministate"

encodeText :: ToJSON a => a -> Text
encodeText = TE.decodeUtf8 . toStrict . Aeson.encode

decodeText :: FromJSON a => Text -> Either String a
decodeText = (Aeson.eitherDecode . fromString) . (Char8.unpack . TE.encodeUtf8)

load :: (FromJSON b) => L.Loader a b c -> IO (Either String [c])
load loader = do
    let dbfile = basedir ++ "/" ++ (loader ^. L.sourceFile)
    createDirectoryIfMissing True basedir
    dbExists <- doesFileExist dbfile
    unless dbExists $ writeFile dbfile "[]"
    content <- readFile dbfile
    case loader ^. L.payload of
      (Just pl) -> return $ mapM ((loader ^. L.linker) (Just pl)) =<< decodeText content
      Nothing -> return $ mapM ((loader ^. L.linker) Nothing) =<< decodeText content

save :: ToJSON b => UL.Unloader a b -> [a] -> IO ()
save unloader txs = writeFile dbfile (serializeMany txs)
  where serializeMany = encodeText . (unloader ^. UL.extractor)
        dbfile = basedir ++ "/" ++ (unloader ^. UL.sourceFile)
