""" Some utility functions. """

import sys


def print_err(*args, **kwargs):
    """ A wrapper around built-in 'print' function connected to stderr. """
    print(*args, **kwargs, file=sys.stderr)

