
base_name = "tests/A2R_"



for n in range(1, 4000, 161):  # 4000
    text = str(n)
    state = 0
    with open(base_name+text+".txt", 'w', newline='\n') as f:
        for c in text:
            f.write(f'{state} {state+1} {c}\n')
            # print(f"{state} {state+1} {c}")
            state += 1
        f.write(str(state))
