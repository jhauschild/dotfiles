#!/usr/bin/env python3

import pickle
import pprint
import gzip
import sys


def pkl_pprint(fn):
    if fn[-4:] == '.pkl':
        with open(fn, 'rb') as f:
            data = pickle.load(f)
    elif fn[-5:] == '.pklz':
        with gzip.open(fn, 'rb') as f:
            data = pickle.load(f)
    else:
        raise ValueError("unexpected file ending")
    pprint.pprint(data)


if __name__ == "__main__":
    for fn in sys.argv[1:]:
        pkl_pprint(fn)
