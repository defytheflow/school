''' Utility functions definitions. '''


import sys

from .constants import SCRIPT, HLP_MSG


def error(*args, fatal:bool = False):
    '''
        Wrapper around built-in 'print' function to print error messages.
    '''
    print(f'{SCRIPT}: ', *args, HLP_MSG, sep='', file=sys.stderr)
    if fatal:
        sys.exit(1)
