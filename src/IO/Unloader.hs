{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}
{-# LANGUAGE TemplateHaskell   #-}

module IO.Unloader (Unloader, sourceFile, extractor) where

import           Lens.Micro.TH

type Extractor a b = [a] -> [b]

data Unloader a b
  = Unloader
      { _sourceFile :: FilePath
      , _extractor  :: Extractor a b
      }

makeLenses ''Unloader
