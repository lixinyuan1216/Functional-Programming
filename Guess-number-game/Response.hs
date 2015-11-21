-- File		: Response.hs
-- Author	:
-- Purpose	:

module Response (response) where
import Data.List
-- | Compute the correct answer to a guess.  First argument is the 
--   target, second is the guess.
		
response :: [String] -> [String] -> (Int, Int, Int)
response target guess = (checkPitch target guess,
						 checkNote leftTarget leftGuess,
						 checkOctave leftTarget leftGuess)
	where
		pitch = getPitch target guess
		leftTarget = removePitch target pitch
		leftGuess = removePitch guess pitch
						
-- | This check two Chord and return their common parts
getPitch :: Eq a => [a] -> [a] -> [a]
getPitch [] xs = []
getPitch xs [] = []
getPitch (x:xs) ys
	| x `elem` ys = x : (getPitch xs (ys \\ [x]))
	| otherwise = getPitch xs ys

-- | This performs a A - B
removePitch :: Eq a => [[a]] -> [[a]] -> [[a]]
removePitch xs [] = xs
removePitch [] xs = []
removePitch xs ys = xs \\ ys

-- | Get note set from a set of Chord
getNote :: Eq a => [[a]] -> [[a]]
getNote [] = []
getNote (x:xs) = [head x] : getNote xs

-- | Get octave set from a set of Chord
getOctave :: Eq a => [[a]] -> [[a]]
getOctave [] = []
getOctave (x:xs) = [last x] : getOctave xs

-- |the first feedback
checkPitch  :: Eq a => [a] -> [a] -> Int
checkPitch target guess = length (getPitch target guess)

-- |the second feedback
checkNote  :: Eq a => [[a]] -> [[a]] -> Int
checkNote target guess = length (getPitch list1 list2)
	where 
		list1 = getNote target
		list2 = getNote guess

-- |the third feedback
checkOctave  :: Eq a => [[a]] -> [[a]] -> Int
checkOctave target guess = length (getPitch list1 list2)
	where 
		list1 = getOctave target
		list2 = getOctave guess

