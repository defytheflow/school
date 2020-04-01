#!/usr/bin/python3
'''
    Functions:

        err(*args) -> print error messages.
'''

import sys

import const


def err(*args):
    ''' Wrapper around built-in 'print' for printing error messages. '''
    print(f'{const.SCRIPT}: ', *args, const.HLP_MSG, sep='', file=sys.stderr)
