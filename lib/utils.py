""" Some utility functions. """

import sys


def printerr(*args, **kwargs):
    """ A wrapper around built-in 'print' function connected to stderr. """
    print(*args, **kwargs, file=sys.stderr)

