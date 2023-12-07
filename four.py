import sys

pisteet = []

for line in open(sys.argv[1]):
    [voittavat, arvaukset] = line.split(':')[1].split('|')
    oikein = len(set(voittavat.split()) & set(arvaukset.split()))
    pisteet.append(oikein)

käsitellyt = 0
kortit = [1] * len(pisteet)

for i, montako in enumerate(kortit):
    for j in range(pisteet[i]):
        kortit[i + j + 1] += montako
    käsitellyt += montako

print(käsitellyt)