import sys

def possible(pull):
    res = {}
    for x in pull.split(","):
        [n, color] = x.split()
        res[color] = int(n)
    return res

sum = 0
for line in open(sys.argv[1]):
    [h, t] = line.split(":")
    g = int(h[5:])
    res = {"red": 0, "blue": 0, "green":0}
    for pull in t.split(";"):
        for color, n in possible(pull).items():
            if res[color] < n:
                res[color] = n
    sum += res["red"] * res["blue"] * res["green"]
print(sum)