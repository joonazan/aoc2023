import sys

up = (0, -1)
down = (0, 1)
left = (-1, 0)
right = (1, 0)

def opposite(dir):
    return (-dir[0], -dir[1])

def directions(pipe):
    if pipe == '|':
        return (up, down)
    elif pipe == '-':
        return (left, right)
    elif pipe == 'L':
        return (up, right)
    elif pipe == 'J':
        return (up, left)
    elif pipe == '7':
        return (down, left)
    elif pipe == 'F':
        return (down, right)
    elif pipe == '.':
        return ()
    elif pipe == 'S':
        return (left, right, down, up)

with open(sys.argv[1]) as f:
    ground = [list(map(directions, line.strip())) for line in f]

for y, line in enumerate(ground):
    for x, p in enumerate(line):
        if len(p) == 4:
            start = (x, y)
            break

def add(a, b):
    return (a[0] + b[0], a[1] + b[1])

def read(pos):
    x, y = pos
    return ground[y][x]

def connections(pos):
    return [add(d, pos) for d in read(pos) if opposite(d) in read(add(d, pos))]

def directions(pos):
    return [d for d in read(pos) if opposite(d) in read(add(d, pos))]

q = [start]
q2 = []
visited = set()
round = 0
while True:
    while q:
        p = q.pop()
        if p in visited:
            continue
        visited.add(p)

        for c in connections(p):
            q2.append(c)
    if not q2:
        break
    q = q2
    q2 = []
    round += 1

def is_enclosed(pos):
    crossings = 0

    # cast a ray from slightly above pos
    # that way it will only intersect pipes going up
    while pos[0] != 0:
        pos = add(pos, left)

        if pos in visited and up in directions(pos):
            crossings += 1

    return crossings % 2 == 1

enclosed = 0
for y in range(len(ground)):
    for x in range(len(ground[0])):
        pos = (x, y)
        if pos in visited:
            continue
        if is_enclosed(pos):
            enclosed += 1
print(enclosed)