{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}
{-# LANGUAGE TemplateHaskell   #-}

module IO.Loader (Loader, sourceFile, payload, linker) where

import           Lens.Micro.TH

type Linker a b c = Maybe [a] -> b -> Either String c

data Loader a b c
  = Loader
      { _sourceFile :: FilePath
      , _payload    :: Maybe [a]
      , _linker     :: Linker a b c
      }

makeLenses ''Loader

