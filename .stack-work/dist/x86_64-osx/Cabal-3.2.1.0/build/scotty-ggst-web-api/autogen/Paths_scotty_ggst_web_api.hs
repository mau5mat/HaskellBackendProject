{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_scotty_ggst_web_api (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/matthewroberts/Documents/Development/haskell/scotty-ggst-web-api/.stack-work/install/x86_64-osx/d6c68f797e6b553d8c9869c0a0d1c9f4a57ec02bd4dbcb831bb4b01a60ec49d5/8.10.7/bin"
libdir     = "/Users/matthewroberts/Documents/Development/haskell/scotty-ggst-web-api/.stack-work/install/x86_64-osx/d6c68f797e6b553d8c9869c0a0d1c9f4a57ec02bd4dbcb831bb4b01a60ec49d5/8.10.7/lib/x86_64-osx-ghc-8.10.7/scotty-ggst-web-api-0.1.0.0-Cp8UQjrqGuYEpeSmK3cLMS-scotty-ggst-web-api"
dynlibdir  = "/Users/matthewroberts/Documents/Development/haskell/scotty-ggst-web-api/.stack-work/install/x86_64-osx/d6c68f797e6b553d8c9869c0a0d1c9f4a57ec02bd4dbcb831bb4b01a60ec49d5/8.10.7/lib/x86_64-osx-ghc-8.10.7"
datadir    = "/Users/matthewroberts/Documents/Development/haskell/scotty-ggst-web-api/.stack-work/install/x86_64-osx/d6c68f797e6b553d8c9869c0a0d1c9f4a57ec02bd4dbcb831bb4b01a60ec49d5/8.10.7/share/x86_64-osx-ghc-8.10.7/scotty-ggst-web-api-0.1.0.0"
libexecdir = "/Users/matthewroberts/Documents/Development/haskell/scotty-ggst-web-api/.stack-work/install/x86_64-osx/d6c68f797e6b553d8c9869c0a0d1c9f4a57ec02bd4dbcb831bb4b01a60ec49d5/8.10.7/libexec/x86_64-osx-ghc-8.10.7/scotty-ggst-web-api-0.1.0.0"
sysconfdir = "/Users/matthewroberts/Documents/Development/haskell/scotty-ggst-web-api/.stack-work/install/x86_64-osx/d6c68f797e6b553d8c9869c0a0d1c9f4a57ec02bd4dbcb831bb4b01a60ec49d5/8.10.7/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "scotty_ggst_web_api_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "scotty_ggst_web_api_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "scotty_ggst_web_api_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "scotty_ggst_web_api_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "scotty_ggst_web_api_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "scotty_ggst_web_api_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
