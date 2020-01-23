import os

stud_fn = os.path.abspath(os.path.join(os.path.dirname(__file__), 'words2.txt'))

with open(stud_fn) as f:
    filedata = f.read().splitlines()

print(len(filedata))