module Main where

import qualified Data.ByteString.Lazy as B
import Data.Word (Word8)
import Lib
import System.Environment (getArgs, getProgName)
import System.Exit (exitFailure)
import Text.Printf (printf)

getCfg :: IO (String, FilePath)
getCfg = do
  pname <- getProgName
  args <- getArgs
  if length args < 2
    then do
      putStrLn (printf "Usage: %s <filename> <compres/decompress>" pname)
      exitFailure
    else return (head args, args !! 1)

writeOutput :: FilePath -> Maybe [Word8] -> IO ()
writeOutput _ Nothing = putStrLn "Failed"
writeOutput fp (Just x) = B.writeFile fp (B.pack x)

main = do
  (mode, fname) <- getCfg
  c <- B.unpack <$> B.readFile fname
  case mode of
    "compress" -> writeOutput (fname ++ ".rhc") $ compress c
    "decompress" -> writeOutput (fname ++ ".out") $ decompress c
    _ -> putStrLn (printf "Usage: %s <filename> <compress/decompress>")
  return ()
