import sys
with open(sys.argv[1]) as f:
    res = 0
    for line in f:
        first = None
        last = None
        digits = ["one", "1", "two", "2", "three","3", "four", "4", "five","5", "six","6", "seven","7", "eight","8", "nine","9"]
        for d in digits:
            pos = line.find(d)
            if pos != -1 and (first == None or pos < line.find(first)):
                first = d

            pos = line.rfind(d)
            if pos != -1 and (last == None or pos > line.rfind(last)):
                last = d

        res += 10 * (digits.index(first) // 2 + 1) + digits.index(last) // 2 + 1
    print(res)