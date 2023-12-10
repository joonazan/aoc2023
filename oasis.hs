diff l = zipWith (-) (tail l) l

lasts = fmap head . takeWhile (not . all (== 0)) . iterate diff

solveLine :: [Int] -> Int
solveLine = foldr (-) 0 . lasts

main = interact (show . sum . fmap (solveLine . fmap read . words) . lines)