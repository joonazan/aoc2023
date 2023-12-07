import Debug.Trace

type Range = (Int, Int, Int)

{- Returns a mapped version of x and how much x must grow so that
 - the output no longer grows at the same rate. -}
apply :: [Range] -> Int -> (Int, Int)
apply mapping x =
    case [let index = x - from in (to + index,  len - index) | (from, to, len) <- mapping, from <= x, x < from + len] of
        [res] -> res
        [] -> (x, distanceToNext x $ fmap (\(from, _, _) -> from) mapping)
        _ -> error "Overlapping ranges!"

distanceToNext :: Int -> [Int] -> Int
distanceToNext x = minimum . filter (> 0) . fmap (\y -> y - x)

multimap :: [[Range]] -> Int -> (Int, Int)
multimap (firstMapping : rest) x =
    foldl
        (\(x, maxMove) mapping ->
            let (x', maxMove') = apply mapping x in
                (x', min maxMove maxMove'))
        (apply firstMapping x)
        rest

solve :: [[Range]] -> [(Int, Int)] -> Int
solve mappings targets = step 0 where
    step x =
        let (x', move) = traceShowId $ multimap mappings x in
            case [x + max x' start - x' | (start, len) <- targets, start < x' + move, x' < start + len] of
                [] -> step (x + move)
                hits -> minimum hits

main = do
    targets <- (pairs . fmap read . words) <$> getLine
    mappings <- readMappings <$> lines <$> getContents
    print $ solve (reverse mappings) targets

pairs (a : b : rest) = (a, b) : pairs rest
pairs [] = []

readMappings lines =
        if mapping == [] then
            []
        else
            parsedMapping : readMappings rest
    where
        (mapping, rest) = span (/= "") $ dropWhile (== "") lines
        parsedMapping = fmap ((\[a, b, c] -> (a, b, c)) . fmap read . words) mapping
            