-- Based on the example program from page 41/42 of 
-- Pacheco "Parallel programming with MPI"

module Main where

import Control.Monad (when, forM_)
import Control.Parallel.MPI.Serializable
import Control.Parallel.MPI.Common

msg :: Rank -> String
msg r = "Greetings from process " ++ show r ++ "!"

comm :: Comm
comm = commWorld

root :: Rank
root = toRank 0

tag :: Tag
tag = toTag ()

main :: IO ()
main = mpi $ do
   rank <- commRank comm
   size <- commSize comm
   if (rank /= root)
      then send comm root tag (msg rank)
      else do forM_ [1..size-1] $ \sender -> do
              (result, _status) <- recv comm (toRank sender) tag
              putStrLn result
