# -*- coding: utf-8 -*-

import csv
from glob import glob

def main():
    mapping_file = 'mapping.csv'
    ### 'oldAccount,Role,newAccount'

    mapping = {}
    with open(mapping_file, 'r') as r:
        reader = csv.reader(r)
        next(reader)

        for line in reader:
            mapping[line[0]] = line[2]

    target_files = list(glob('./channel_members_*')) + list(glob('./members_*'))

    for f in target_files:
        mappingUsers(mapping, f)

    
def mappingUsers(mapping, fname):
    ### "UserId","User","Name","Role"

    with open(fname, 'r') as r:
        reader = csv.reader(r)
        next(reader)

        rows = []
        for line in reader:
            if line[1] not in mapping:
                print(f'Mapping of a user not found: {line[1]}')
            else:
                rows.append((mapping[line[1]], line[3]))

    out_file = fname.replace('.csv', '_mapped.csv')
    with open(out_file, 'w') as w:
        writer = csv.writer(w)
        writer.writerow(('User', 'Role'))
        writer.writerows(rows)

if __name__ == "__main__":
    main()
