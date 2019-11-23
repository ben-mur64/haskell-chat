module Benchat.Network where
  ( connectSocket
  , readMessage
  , writeMessage
  ) where

import Network.Socket
import qualified Network.Socket.ByteString as NBS
import Data.ByteString (ByteString)
import qualified Data.ByteString as ByteString
import Data.ByteString.Char8 (unpack)
import Data.Read (readMaybe)
import Data.Aeson (decodeStrict, encode)
import Data.ByteString.Lazy (toStrict)

connectSocket = do
  sock <- socket AF_INET Stream 0
  setSocketOption sock ReuseAddr 1
  bind sock $ SockAddrInet 42069 iNADDR_ANY
  listen sock 2
  return sock

readMessage socket = do
  size <- NBS.recv socket 24
  let rsize = readSize size
  case rsize of
    Nothing -> return Nothing
    (Just jsize) -> do
      msg <- NBS.recv socket jsize
      return $ decodeStrict msg

writeMessage socket value = do
  let serialized = toStrict $ encode value
  let len = ByteString.length serialized
  let lenStr = padBSLeft 24 $ pack $ show len
  NBS.send socket lenStr
  NBS.send socket serialized
  return ()

readSize :: ByteString -> Maybe Int
readSize bs = readMaybe $ unpack bs

padBS :: Int -> ByteString -> ByteString
padBSLeft size str
  | size == ByteString.length str = str
  | size < ByteString.length = error "Passed a big size to padBSLeft, no no no"
  | otherwise = padBSLeft size (pack " " <> str)
