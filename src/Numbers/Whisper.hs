-- |
-- Module      : Numbers.Whisper
-- Copyright   : (c) 2012 Brendan Hay <brendan@soundcloud.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan@soundcloud.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--

module Numbers.Whisper (
    -- * Opaque
      Whisper
    , newWhisper

    -- * Operations
    , insert

    -- * Formatters
    , json
    , text
    ) where

import Blaze.ByteString.Builder        (Builder, copyLazyByteString)
import Control.Arrow                   (second)
import Control.Monad                   (liftM)
import Data.Aeson               hiding (json)
import Data.Text.Encoding              (decodeUtf8)
import Numbers.Types
import Numbers.Whisper.Series          (Resolution, Series, Step)

import qualified Numbers.Map            as M
import qualified Numbers.Whisper.Series as S

data Whisper = Whisper
    { _res   :: Resolution
    , _step  :: Step
    , _db    :: M.Map Key Series
    }

newWhisper :: Int -> Int -> IO Whisper
newWhisper res step = do
    db <- M.empty $ M.Reset res (\_ _ _ -> return ())
    return $! Whisper (res `div` step) step db
-- ^ Investigate implications of div absolute rounding torwards zero

insert :: Time -> Point -> Whisper -> IO ()
insert ts (P k v) Whisper{..} = M.update k f _db
  where
    f = return . maybe (S.create _res _step ts v) (S.update ts v)

json :: Time -> Time -> Whisper -> IO Builder
json from to w =
    (copyLazyByteString . encode . object . map f) `liftM` fetch from to w
  where
    f (Key k, s) = decodeUtf8 k .= toJSON s

text :: Time -> Time -> Whisper -> IO Builder
text from to w = (build . map f) `liftM` fetch from to w
  where
    f (Key k, s) = k &&> "," &&& s &&> "\n"

fetch :: Time -> Time -> Whisper -> IO [(Key, Series)]
fetch from to Whisper{..} = map (second (S.fetch from to)) `liftM` M.toList _db
