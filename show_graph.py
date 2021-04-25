import matplotlib.pyplot as plt

file_name = ".history"

times = []
errors = []
val_errors = []

with open(file_name, 'r') as f:

    times.append(f.readline())

    error_line = f.readline()
    val_error_line = f.readline()

    errors = list(map(lambda x: float(x), error_line.split(' ')))
    val_errors = list(map(lambda x: float(x), val_error_line.split(' ')))

    f.close()

print(f'Len errors: {len(errors)}')

plt.plot(range(1, len(errors) + 1), errors, label='Train error')
plt.plot(range(1, len(val_errors) + 1), val_errors, label='Val error')

plt.xlabel('Generation', fontsize=14)
plt.ylabel('Error', fontsize=14)

plt.legend()

plt.show()