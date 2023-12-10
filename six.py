from math import sqrt, floor, ceil

time = int(input().split(":")[1].replace(" ", ""))
record = int(input().split(":")[1].replace(" ", ""))

result = 1

start = ceil(0.5 * (time - sqrt(time * time - 4 * record)))
end = floor(0.5 * (time + sqrt(time * time - 4 * record)))
solutions = end - start + 1
result *= solutions

print(result)