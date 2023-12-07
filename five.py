seeds = list(map(int, input().split()))
categories = []

for _ in range(7):
    cat = []
    line = input()
    while line != "":
        cat.append(list(map(int, line.split())))
        line = input()
    categories.append(cat)

smallest_location = float("inf")

ranges = [(start, start + length) for start, length in zip(seeds[::2], seeds[1::2])]

for cat in categories:
    mapped = []

    for [out, start2, length2] in cat:
        end2 = start2 + length2
        def add_fragment(start, end):
            mapped_start = out + start - start2
            mapped.append((mapped_start, mapped_start + end - start))

        unmapped = []
        for start, end in ranges:
            if start2 <= start and end <= end2:
                add_fragment(start, end)
            elif start <= start2 and end2 <= end:
                unmapped.append((start, start2))
                add_fragment(start2, end2)
                unmapped.append((end2, end))
            elif start2 < end <= end2:
                unmapped.append((start, start2))
                add_fragment(start2, end)
            elif start < end2 <= end:
                add_fragment(start, end2)
                unmapped.append((end2, end))
            else:
                unmapped.append((start, end))
        ranges = unmapped

    ranges = mapped + unmapped
                
print(min(map(lambda x: x[0], ranges)))