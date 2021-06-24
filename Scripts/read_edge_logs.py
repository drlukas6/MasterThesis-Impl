import matplotlib.pyplot as plt

errs = {}

print(f'reading: {type}.log')
with open(f'no_all_edge.log', 'r') as file:

    for _ in range(0, 13):
        description_line_parts = file.readline().strip().split(' ')
        missing = description_line_parts[-1]
        err_line = file.readline().strip().split(' ')
        err = float(err_line[-1])

        errs[missing] = err

print(errs.keys())

sorted_v = {k: v for k, v in sorted(errs.items(), key=lambda item: item[1])}

for key, value in sorted_v.items():
    print(f'{key.upper()} \t = {value} \t DIFF = {value/errs["none"]}')
