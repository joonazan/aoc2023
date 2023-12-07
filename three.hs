import Data.List
import Debug.Trace

main = interact solve

solve :: String -> String
solve input = show $ sum $ fmap solveLine $ slidingWindow (repeat '.' : lines input ++ [repeat '.'])

solveLine :: [String] -> Integer
solveLine lines = solveLine' stars (foldl (++) [] $ fmap numbers lines) where
    stars = fmap snd $ filter ((== '*') . fst) $ zip (lines !! 1) [0..]
    numbers :: String -> [Number]
    numbers line = fmap (\x -> Number
        { start = snd $ head x
        , end = snd $ last x
        , value = read $ fmap fst x }) $
        filter (isNum . fst . head) $
        groupBy (\a b -> isNum (fst a) == isNum (fst b)) $ zip line [0..]

data Number = Number
    { start :: Integer
    , end :: Integer
    , value :: Integer }
    deriving Show

solveLine' :: [Integer] -> [Number] -> Integer
solveLine' stars nums = sum $ fmap findStar stars where
    findStar star = case nearby star of
        [a, b] -> value a * value b
        _ -> 0
    nearby star = filter (\x -> start x - 1 <= star && star <= end x + 1) nums

isSymbol x = not $ elem x "1234567890."
isNum x = elem x "1234567890"

slidingWindow :: [a] -> [[a]]
slidingWindow list =
    if length tip == 3 then
        tip : slidingWindow (tail list)
    else
        []
    where
        tip = take 3 list