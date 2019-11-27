module Benchat.Communicate where

import Control.Concurrent.STM.TQueue
import Control.Concurrent.STM.TChan
import Control.Monad.STM

import Benchat.Message
{-
1. Everybody pushes messages onto a queue
2. Some master reader thread reads messages from the queue, and pushes them onto a broadcast channel
3. Everybody reads from the channel

Queue: many writers, potentially many readers, put stuff on, one person takes them off
Channel: two-way communication, using some constructs, can be """hacked""" to be like TV (one guy broadcasts, many people get the broadcast)
-}

type MasterMessageQueue = MasterMessageQueue (TQueue NamedMessage)

-- Make a new queue of messages that will be used by the master broadcast thread
newChatQueue :: IO (TQueue NamedMessage)
newChatQueue = MasterMessageQueue <$> newTQueueIO

-- Create a master broadcast channel to be used by the master broadcast thread
newBroadcastChan :: IO (TChan NamedMessage)
newBroadcastChan = newBroadcastTChanIO

-- Make a duplicate of a master broadcast channel to be read by a thread that routes messages down the socket
makeReadChan :: TChan NamedMessage -> IO (TChan NamedMessage)
makeReadChan message = atomically $ dupTChan message
