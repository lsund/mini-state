{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}
{-# LANGUAGE TemplateHaskell   #-}

module IO.Unloader where

import Lens.Micro.TH

type Extractor a b = [a] -> [b]

-- A specification how to unload a table of type `b`.
-- `b` is generated from `a` by specifying an extractor
data Unloader a b
  = Unloader
      { _sourceFile :: FilePath
      , _extractor  :: Extractor a b
      }

makeLenses ''Unloader
