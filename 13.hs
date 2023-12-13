import Data.List

reflectionAxes xs = filter isAxis [1 .. length xs - 1] where
    isAxis i =
        let (start, end) = splitAt i xs in (== 1) $ sum $ zipWith countDifferences (reverse start) end

countDifferences a b = sum $ zipWith (\a b -> if a == b then 0 else 1) a b

solveOne xs =
    case reflectionAxes xs of
        [] -> let [axis] = reflectionAxes $ transpose xs in axis
        [axis] -> 100 * axis

main = interact (show . sum . fmap solveOne . readMaps . lines)

readMaps :: [String] -> [[String]]
readMaps [] = []
readMaps input =
    let (rect, rest) = span (/= "") $ dropWhile (== "") input
    in rect : readMaps rest