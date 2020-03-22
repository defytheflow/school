import sys

from pprint import pprint
from typing import Any


def ls(obj: Any = None):
    """ Prettier version of 'dir' built-in. """
    import __main__
    if obj:
        pprint(dir(obj))
    else:
        pprint(dir(__main__))
