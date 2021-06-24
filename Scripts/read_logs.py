import matplotlib.pyplot as plt

types = ['avg', 'max', 'mean', 'modsum', 'sqrtsum', 'min', 'maxmindiff', 'org_1', 'org_2', 'org_3']

type_errs = {}

for type in types:
    print(f'reading: {type}.log')
    with open(f'no_{type}.log', 'r') as file:
        file.readline()
        line = file.readline().strip()
        numbers = list(map(lambda x: float(x) / 255, line[1:len(line)-1].split(', ')))

        type_errs[type] = numbers[400:]

print(type_errs.keys())

type_last = {'ORIGINAL': 0.01859398659}

for key, value in type_errs.items():
    type_last[key] = value[-1]

sorted_v = {k: v for k, v in sorted(type_last.items(), key=lambda item: item[1])}

avg_org = sorted_v['org_1'] + sorted_v['org_2'] + sorted_v['org_3']
avg_org /= 3

for key, value in sorted_v.items():
    print(f'{key.upper()} \t = {value} \t DIFF = {value/avg_org}')


for key, value in type_errs.items():
    plt.plot(range(1, len(value) + 1), value, label=f'no {key}')

plt.legend()
plt.show()