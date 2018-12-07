#!/usr/bin/python2
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
