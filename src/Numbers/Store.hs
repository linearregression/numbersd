-- |
-- Module      : Numbers.Store
-- Copyright   : (c) 2012 Brendan Hay <brendan@soundcloud.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan@soundcloud.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--

module Numbers.Store (
      runStore
    ) where

import Control.Monad
import Control.Monad.IO.Class
import Control.Concurrent.STM
import Numbers.Conduit
import Numbers.Types

import qualified Data.ByteString.Char8 as BS
import qualified Numbers.Map           as M

runStore :: [Int]
         -> Int
         -> [EventSink]
         -> TBQueue BS.ByteString
         -> IO ()
runStore qs n sinks q = do
    m <- liftIO . M.empty $ M.Continue n f
    forever $ atomically (readTBQueue q) >>= liftIO . parse sinks m
  where
    f k m ts = mapM_ (\p -> pushEvents sinks [Flush k m ts, Aggregate p ts])
        $! calculate qs n k m

parse :: [EventSink] -> M.Map Key Metric -> BS.ByteString -> IO ()
parse sinks m bstr = forM_ (filter (not . BS.null) $ BS.lines bstr) f
  where
    f b = do
        pushEvents sinks [Receive b]
        measure "packets_received" m
        case decode lineParser b of
            Just (k, v) -> do
                measure "num_stats" m
                pushEvents sinks [Parse k v]
                insert k v m
            Nothing -> do
                measure "bad_lines_seen" m
                pushEvents sinks [Invalid b]

measure :: Key -> M.Map Key Metric -> IO ()
measure = flip insert (Counter 1)

insert :: Key -> Metric -> M.Map Key Metric -> IO ()
insert key val = M.update key (aggregate val)
