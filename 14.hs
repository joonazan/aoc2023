import Data.List

solveColumn :: String -> String
solveColumn x = solveColumn' x 0 0

solveColumn' ('#' : t) rocks empties = replicate rocks 'O' ++ replicate empties '.' ++ ('#' : solveColumn' t 0 0)
solveColumn' ('.': t) rocks empties = solveColumn' t rocks (empties + 1)
solveColumn' ('O': t) rocks empties = solveColumn' t (rocks + 1) empties
solveColumn' [] rocks empties = replicate rocks 'O' ++ replicate empties '.'

scoreColumn :: String -> Int
scoreColumn rocks = sum $ fmap fst $ filter ((== 'O') . snd) $ zip (reverse [1 .. length rocks]) rocks

oneCycle :: [String] -> [String]
oneCycle = fmap (reverse . solveColumn . reverse) .
    transpose . fmap (reverse . solveColumn . reverse) . transpose .
    fmap solveColumn .
    transpose . fmap solveColumn . transpose

findRepetition list = findRepetition' [] list
findRepetition' previous (h : t) =
    if elem h previous then
        span (/= h) (reverse previous)
    else
        findRepetition' (h : previous) t

solve :: [String] -> Int
solve input = sum $ fmap scoreColumn $ transpose $ repeating !! index where
    (start, repeating) = findRepetition $ iterate oneCycle input
    index = mod (1000000000 - (length start)) (length repeating)

main = interact (show . solve . lines)