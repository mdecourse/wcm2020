import os

stud_fn = os.path.abspath(os.path.join(os.path.dirname(__file__), '12960_vocabulary.txt'))

with open(stud_fn) as f:
    filedata = f.read().splitlines()

for i in range(len(filedata)):
    print(filedata[i].split(" ")[1])