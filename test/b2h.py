#!/usr/bin/python2

# binary to hex
# eg:
# input: b.txt
#       insts[1] = 16'b01101_001_110_00000; // LI R1 C0
#       insts[2] = 16'b01101_010_000_00001; // LI R2 1
# output: console
#           69C0
#           6A01

import string, sys

def first(the_iterable, condition = lambda x: True):
    for i,li in enumerate(the_iterable):
        if condition(li):
            return i, li

with open("b.txt") as f:
    lines = f.readlines()
    for line in lines:
        if len(line.strip())>3:
            x = line.strip().replace(' ', '').replace('_', '')
            if(x[0]!='/'):
                beg,s = first(list(x), lambda i: i=='\'')
                end,s = first(list(x), lambda i: i==';')
                l = x[beg+2:end]
                print(("%04x"%(int(l, 2))).upper())
        else:
            print(" ")
