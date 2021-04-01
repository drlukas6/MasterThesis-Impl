import matplotlib.pyplot as plt

file_name = ".history"

fitnesses = []
errors = []

with open(file_name, 'r') as f:

    fitness_line = f.readline()
    error_line = f.readline()

    fitnesses = list(map(lambda x: float(x), fitness_line.split(' ')))
    errors = list(map(lambda x: float(x), error_line.split(' ')))

    f.close()

with open(file_name, 'w') as f:

    f.write('')

    f.close()

print(f'Len errors: {len(errors)}')
plt.plot(range(1, len(errors) + 1), errors)

plt.xlabel('Generation', fontsize=14)
plt.ylabel('Error', fontsize=14)

plt.show()