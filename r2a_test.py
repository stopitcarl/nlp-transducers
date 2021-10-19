
base_name = "tests/R2A_"


def int_to_roman(num):

    # Storing roman values of digits from 0-9
    # when placed at different places
    m = ["", "M", "MM", "MMM"]
    c = ["", "C", "CC", "CCC", "CD", "D",
         "DC", "DCC", "DCCC", "CM"]
    x = ["", "X", "XX", "XXX", "XL", "L",
         "LX", "LXX", "LXXX", "XC"]
    i = ["", "I", "II", "III", "IV", "V",
         "VI", "VII", "VIII", "IX"]

    # Converting to roman
    thousands = m[num // 1000]
    hundereds = c[(num % 1000) // 100]
    tens = x[(num % 100) // 10]
    ones = i[num % 10]

    ans = (thousands + hundereds +
           tens + ones)

    return ans

for n in range(1, 4000, 105):  # 4000
    text = int_to_roman(n)
    state = 0
    with open(base_name+text+".txt", 'w', newline='\n') as f:
        for c in text:
            f.write(f'{state} {state+1} {c}\n')
            # print(f"{state} {state+1} {c}")
            state += 1
        f.write(str(state))
