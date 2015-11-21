-- File		: Main.hs
-- Author	: xinyuanl3
-- Purpose	: 

module Proj1 (initialGuess, nextGuess, GameState) where
import Response
import Chord
import Data.List
import Data.Ord

-- | Define the gamesate type. That is the collection of 
--   possible target.
data GameState = GameState {state::[[Chord]]} deriving Show

-- | The count of total distinguish chordsa at first (3 * 7)
whole_chord_pool = 21

-- | Initial the original gamestate and initial guess ["A1", "B2", "C3"]
initialGuess :: ([String],GameState)
initialGuess = (["A1", "B2", "C3"],initialState)
	where
		initialState = GameState (candicate 3 (allChord whole_chord_pool))

-- | Get all the candicate combination of chrod
candicate :: Int -> [a] -> [[a]]
candicate 0 _  = [ [] ]
candicate n xs = [ y:ys | y:xs' <- tails xs
                           , ys <- candicate (n-1) xs']

-- | Get the set of all Chord
allChord :: Int -> [Chord]
allChord 0 = []
allChord n = [toEnum (n-1) :: Chord] ++ allChord (n-1)

nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)
nextGuess (pGuess,pState) feedback = (nGuess,nState)
	where
		nState = filterChord (pGuess,pState) feedback
		chords = state nState
		nIndex = snd (mini(worstSet chords chords))
		nGuess = getString (chords !! nIndex) 


-- | Filter previous gamastate and pare it down to generate next
-- gamestate.
filterChord :: ([String],GameState) -> (Int,Int,Int) -> GameState
filterChord (pGuess,prevState) feedback = GameState([a | a <- state prevState, 
							response [show (a!!0), show (a!!1), show (a!!2)] pGuess == feedback])

-- | Get the expected remaining list of each element in the previous state. 
worstSet :: [[Chord]] -> [[Chord]] -> [Int]
worstSet guesses chords = [responseSet a chords | a <- guesses]

-- | Get the maximum remaining set for the guess
-- That's is, the largest remaining set size
-- I tried the expected size, but performed not better.  
responseSet :: [Chord] -> [[Chord]] -> Int
responseSet guess chords = maximum (frequency [response (getString a) (getString guess) | a <- chords])

-- | Get the mean of a list of number.
averageList :: (Real a, Fractional b) => [a] -> b
averageList xs = realToFrac (sum xs) / genericLength xs

-- | Get the max number and its index from a list.
mini :: (Enum b, Num b, Ord a) => [a] -> (a, b)
mini xs = minimumBy (comparing fst) (zip xs [0..])

-- | Count the frequency of each element in the list
frequency :: Ord a => [a] -> [Int] 
frequency list = map (\l -> (length l)) (group (sort list))

-- | Convert [Chord] to [String]
getString :: [Chord] -> [String]
getString a = [show (a!!0), show (a!!1), show (a!!2)]

