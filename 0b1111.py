import sys

def hash(s):
    h = 0
    for c in s:
        h += ord(c)
        h *= 17
        h %= 256
    return h

with open(sys.argv[1]) as f:
    lenses = {}
    for i, x in enumerate(f.read().replace('\n', '').split(',')):
        equals = x.find('=')
        dash = x.find('-')
        if equals != -1:
            label = x[:equals]
            focal = int(x[equals+1])
            if label in lenses:
                lenses[label][1] = focal
            else:
                lenses[label] = [i, focal]
        else:
            label = x[:dash]
            if label in lenses:
                del lenses[label]

    boxes = [[] for _ in range(256)]
    for l in lenses:
        boxes[hash(l)].append(lenses[l])

    total = 0
    for ib, b in enumerate(boxes):
        b.sort()
        for i, l in enumerate(b):
            total += (i + 1) * l[1] * (ib + 1)
    
    print(total)