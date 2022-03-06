module Lib
  ( compress
  , decompress
  ) where

import Data.Word (Word8)

findUnused :: [Word8] -> Maybe Word8
findUnused xs
  | null l = Nothing --every possible Word8 is used
  | otherwise = Just $ head l
  where
    l = [x | x <- [0 .. 255], x `notElem` xs]

header :: Word8 -> [Word8]
header r = [82, 72, 76] ++ [r, 10]

findRepeat :: [Word8] -> Int -> Word8
findRepeat xs i = fromIntegral $ fr xs i i - i
  where
    fr xs i o
      | i - o >= 255 = 255
      | length xs <= (i + 1) || xs !! i /= xs !! (i + 1) = i
      | otherwise = fr xs (i + 1) o

comp :: [Word8] -> Int -> Word8 -> [Word8]
comp xs i r
  | length xs <= i = []
  | rel == 0 = (xs !! i) : comp xs (i + 1) r
  | otherwise =
    r :
    fromIntegral (rel + 1) : (xs !! i) : comp xs (i + fromIntegral rel + 1) r
  where
    rel = findRepeat xs i

decomp :: [Word8] -> Int -> Word8 -> Maybe [Word8]
decomp xs i r
  | length xs <= (i + 3) = Just $ drop i xs
  | cb /= r = do
    res <- decomp xs (i + 1) r
    return (cb : res)
  | otherwise = do
    res <- decomp xs (i + 3) 0
    return (replicate (fromIntegral rn) rb ++ res)
  where
    cb = xs !! i
    rn = xs !! (i + 1)
    rb = xs !! (i + 2)

compress :: [Word8] -> Maybe [Word8]
compress xs = do
  rb <- findUnused xs
  return (header rb ++ comp xs 0 rb)

findRepeatByte :: [Word8] -> Maybe Word8
findRepeatByte xs
  | length xs < 4 = Nothing
  | otherwise = Just (xs !! 3)

decompress :: [Word8] -> Maybe [Word8]
decompress xs = decomp xs 5 =<< findRepeatByte xs
