import sys, itertools

m = {}

with open(sys.argv[1]) as f:
    directions = list(map(lambda x: 0 if x == "L" else 1, next(f).strip()))
    next(f)
    for line in f:
        line = line.replace(" ", "")
        [src, rest] = line.split("=")
        l = rest[1:4]
        r = rest[5:8]
        m[src] = (l, r)

starts = list(filter(lambda x: x[2] == "A", m))

def cycle(start):
    pos = start
    ends = []
    visited = {}
    for step in range(len(m) * len(directions)):

        di = step % len(directions)

        if (pos, di) in visited:
            start = visited[(pos, di)]
            [goal] = ends
            return goal, step - start
        visited[(pos, di)] = step

        if pos[2] == "Z":
            ends.append(step)

        d = directions[di]
        pos = m[pos][d]

(steps, cycle_lengths) = zip(*(cycle(s) for s in starts))
steps = list(steps)
print(steps, cycle_lengths)

while any(map(lambda x: x != steps[0], steps)):
    mindex = min(range(len(steps)), key=lambda i: steps[i])
    steps[mindex] += cycle_lengths[mindex]