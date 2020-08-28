import io
import readline
import sys
from typing import Callable, TextIO, Union


def get_int(prompt: str = '',
            force: bool = False,
            stream: TextIO = sys.stdin) -> Union[int, None]:
    '''
        Get a line of text from 'stream' and try to convert it to an int.
        If 'force' is True, prompts user until gets a valid int value.
        Optional 'stream' paramater can be set to read input from a file.
    '''
    if not isinstance(stream, io.TextIOWrapper):
        raise ValueError("'get_int' - Invalid type of 'stream' argument.")

    while True:
        try:
            i = int(get_string(prompt, stream))
        except (ValueError, TypeError, EOFError):
            if not force:
                return None
        else:
            return i


def get_float(prompt: str = '',
              force: bool = False,
              stream: TextIO = sys.stdin) -> Union[float, None]:
    '''
        Get a line of text from 'stream' and try to convert it to a float.
        If 'force' is True, prompts user until gets a valid float value.
        Optional 'stream' paramater can be set to read input from a file.
    '''
    if not isinstance(stream, io.TextIOWrapper):
        raise ValueError("'get_float' - Invalid type of 'stream' argument.")

    while True:
        try:
            f = float(get_string(prompt, stream))
        except (ValueError, TypeError, EOFError):
            if not force:
                return None
        else:
            return f


def get_string(prompt: str = '',
               stream: TextIO = sys.stdin) -> Union[str, None]:
    '''
        Get a line of text from 'stream'.
        Optional 'stream' paramater can be set to read input from a file.
    '''
    if not isinstance(stream, io.TextIOWrapper):
        raise ValueError("'get_string' - Invalid type of 'stream' argument.")

    stdin = sys.stdin  # original reference to sys.stdin

    # if not reading from stdin, do not display the prompt
    if stream != stdin:
        prompt = None
        sys.stdin = stream  # input() reads from stdin

    while True:
        if prompt is not None:
            print(prompt, end='')
        try:
            s = input()
        except (EOFError, KeyboardInterrupt):
            return None
        else:
            return s
        finally:
            sys.stdin = stdin


def get_input(prompt: str = '',
              type_: Callable = str,
              force: bool = False,
              stream: TextIO = sys.stdin) -> Union[str, int, float, None]:
    '''
        Get a line of text from 'stream' and try to convert it to
        some datatype using 'type_' callable.

        If 'force' is True, prompts user until gets a convertable value.
        Optional 'stream' paramater can be set to read input from a file.
    '''
    # Check 'type_' argument
    if not callable(type_):
        raise ValueError("'get_input' - Invalid type of 'type_' argument.")

    # Check 'stream' argument
    if not isinstance(stream, io.TextIOWrapper):
        raise ValueError("'get_input' - Invalid type of 'stream' argument.")

    stdin = sys.stdin  # original reference to sys.stdin

    # if not reading from stdin, do not display the prompt
    if stream != stdin:
        prompt = None
        sys.stdin = stream  # input() reads from stdin

    while True:
        if prompt is not None:
            print(prompt, end='')
        try:
            input_ = type_(input())
        except (ValueError, TypeError, EOFError, KeyboardInterrupt):
            if not force:
                return None
        else:
            return input_
        finally:
            sys.stdin = stdin


def print_err(*args, **kwargs) -> None:
    ''' A wrapper around built-in 'print' function connected to stderr. '''
    print(*args, **kwargs, file=sys.stderr)


def error(message: str = '', status: int = 1, fatal: bool = False) -> None:
    '''
        Prints an error message prepended with "Error: " to stderr.
        If 'fatal' is True, terminates the program with exit status 'status'.
    '''
    print('Error:', message, file=sys.stderr)
    if fatal:
        if isinstance(status, int):
            sys.exit(status)
        else:
            sys.exit(1)
