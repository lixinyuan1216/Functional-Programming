-- File		: Chord.hs
-- Author	: xinyuanl3
-- Purpose	: 

-- | This implement a Chord type, including note
-- and octave.
module Chord(Note(..), Octave(..), Chord(..)) where
import Data.List

-- | This define the note for the chord.
data Note = A | B | C | D | E | F | G 
	deriving (Eq, Ord, Bounded, Enum)
notechars = "ABCDEFG"

-- | This define the octave for the chord.
data Octave = One | Two | Three
	deriving (Eq, Ord, Bounded, Enum)
octavechars = "123"

-- | This define the constructor fot the chord.
data Chord = Chord {note::Note, octave::Octave}
          deriving (Eq, Bounded)

-- | This defines the show function for note.
instance Show Note where
    show n = [notechars !! fromEnum n]

-- | This defines the show function for octave.
instance Show Octave where
    show o = [octavechars !! fromEnum o]

-- | This defines the show function for chord.
instance Show Chord where
    show (Chord n o) = show n ++ show o

-- | This help to get the collection of all the 
-- chord set.
instance Enum Chord where
    fromEnum (Chord n o) = (fromEnum n) * 3 + (fromEnum o)
    toEnum m = (Chord n o)
      where n = toEnum (m `div` 3)
            o = toEnum (m `mod` 3)

