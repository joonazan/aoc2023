import Data.List
import Control.Monad
import Control.Monad.State
import Data.Array.Unboxed
import Data.Word

rowSpans :: Int -> String -> State Int [(Int, (Int, Int), Int)]
rowSpans _ [] = pure []
rowSpans i col@('#': _) = rowSpans (i + length wall) col' where
    (wall, col') = span (== '#') col
rowSpans i col = do
    let (free, col') = span (/= '#') col
    let rocks = length $ filter (== 'O') free
    span_no <- next
    rest <- rowSpans (i + length free) col'
    pure $ (span_no, (i, i + length free), rocks) : rest

next :: State Int Int
next = do
    x <- get
    modify (+1)
    pure x

solve pattern = fst $ repeating !! index where
    (rows, numRowSpans) = runState (mapM (rowSpans 0) pattern) 0
    (columns, numColSpans) = runState (mapM (rowSpans 0) $ transpose pattern) 0
    wToS = zip [0..] rows >>= (\(y, row) -> fmap (\(_, interval, _) -> spanIntersections columns y interval) row)
    nToW = zip [0..] columns >>= (\(y, row) -> fmap (\(_, interval, _) -> spanIntersections rows y interval) row)
    eToN = reverse <$> wToS
    sToE = reverse <$> nToW

    shift :: [[Int]] -> Int -> UArray Int Word8 -> UArray Int Word8
    shift mapping bound rocks = accumArray (+) 0 (0, bound - 1) $
        join $ zipWith (\rocks placement -> (, 1) <$> take (fromIntegral rocks) placement) (elems rocks) mapping

    oneCycle =
        shift sToE numRowSpans .
        shift wToS numColSpans .
        shift nToW numRowSpans .
        shift eToN numColSpans

    -- This method represents the stones as if they've already slid,
    -- so we need to do a partial cycle to get a starting arrangement where they point to the east
    initialHor =
        shift sToE numRowSpans .
        shift wToS numColSpans .
        shift nToW numRowSpans .
        array (0, numColSpans - 1) $ columns >>= (fmap (\(no, _, rocks) -> (no, fromIntegral rocks)))

    (start, repeating) = findRepetition $ fmap (\x -> (score x, x)) $ iterate oneCycle initialHor
    index = mod (1000000000 - 1 - (length start)) (length repeating)

    score rocks = sum $ zipWith (*) (fromIntegral <$> elems rocks) spanScores
    spanScores = zip [0..] rows >>= (\(y, row) -> replicate (length row) (length rows - y))

spanIntersections columns row (start, end) = fmap oneSquare [start..end-1] where
    oneSquare x = no where
        [(no, _, _)] = filter (\(_, (start, end), _) -> start <= row && row < end) $ columns !! x

findRepetition list = findRepetition' [] list
findRepetition' previous (h : t) =
    if elem h previous then
        span (/= h) (reverse previous)
    else
        findRepetition' (h : previous) t

main = interact ((++ "\n") . show . solve . lines)