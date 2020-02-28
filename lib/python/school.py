"""
    This module consists of useful functions to be used during coding lessons.
"""

import io
import sys
import readline

from typing import TextIO, Callable, Union


def get_int(prompt: str = "", force: bool = False,
            stream: TextIO = sys.stdin) -> int:
    """
        Get a line of text from 'stream' and try to convert it to an int.
        If 'force' is True, prompts user until gets a valid int value.

        Args:
          prompt (str)    : the prompt to display (default - "").
          force  (bool)   : toggles force mode (default - False).
          stream (TextIO) : file stream to read from (default - sys.stdin).

        Returns:
          int :  input can be converted to an int.
          None:  input can not be converted to an int or reached EOF.

        Exits on SIGINT
    """
    if not isinstance(stream, io.TextIOWrapper):
        raise ValueError("'get_int' - Invalid type of 'stream' argument.")

    while True:
        try:
            i = int(get_string(prompt, stream))
        except (ValueError, TypeError):
            if force:
                continue
            else:
                return None
        except EOFError:
            if force:
                print()
                continue
            else:
                return None
        except KeyboardInterrupt:
            sys.exit("")
        else:
            return i


def get_float(prompt: str = "", force: bool = False,
              stream: TextIO = sys.stdin) -> float:
    """
        Get a line of text from 'stream' and try to convert it to a float.
        If 'force' is True, prompts user until gets a valid float value.

        Args:
          prompt (str)    : the prompt to display (default - "").
          force  (bool)   : toggles force mode (default - False).
          stream (TextIO) : file stream to read from (default - sys.stdin).

        Returns:
            float:  input can be converted to a float.
            None:   input can not be converted to a float or reached EOF.

        Exits on SIGINT
    """
    if not isinstance(stream, io.TextIOWrapper):
        raise ValueError("'get_float' - Invalid type of 'stream' argument.")

    while True:
        try:
            f = float(get_string(prompt, stream))
        except (ValueError, TypeError):
            if force:
                continue
            else:
                return None
        except EOFError:
            if force:
                print()
                continue
            else:
                return None
        except KeyboardInterrupt:
            sys.exit("")
        else:
            return f


def get_string(prompt: str = "", stream: TextIO = sys.stdin) -> str:
    """
        Get a line of text from 'stream'.

        Args:
          prompt (str)    : the prompt to display    (default - "").
          stream (TextIO) : file stream to read from (default - sys.stdin).

        Returns:
            str:  input is not EOF.
            None: reached EOF.

        Exits on SIGINT
    """
    if not isinstance(stream, io.TextIOWrapper):
        raise ValueError("'get_string' - Invalid type of 'stream' argument.")

    stdin = sys.stdin  # original reference to sys.stdin

    # if not reading from stdin, do not display the prompt
    if stream != stdin:
        prompt = None
        sys.stdin = stream  # input() reads from stdin

    while True:
        if prompt is not None:
            print(prompt, end="")
        try:
            s = input()
        except EOFError:
            return None
        except KeyboardInterrupt:
            sys.exit("")
        else:
            return s
        finally:
            sys.stdin = stdin


def get_input(prompt: str = "", type_: Callable = str, force: bool = False,
              stream: TextIO = sys.stdin) -> Union[str, int, float]:
    """

        Get a line of text from 'stream' and try to convert it to
        some datatype using 'type_' callable.

        If 'force' is True, prompts user until gets a convertable value.
        Optional 'stream' paramater can be set to read input from a file.

        Args:
          prompt (str)      : prompt to display (default - "").
          type_  (Callable) : callable used to convert the return value to
                              required datatype (default - str).
          force  (bool)     : toggles force mode (default - False).
          stream (TextIO)   : file stream to read from (default - sys.stdin).

        Returns:
          str  : 'type_' is 'str'
          int  : 'type_' is 'int' and input can be converted to int.
          float: 'type_' is 'float' and input can be converted to float.
          None :  input can not be converted with 'type_' or reached EOF.

        Exits on SIGINT

    """
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
            print(prompt, end="")
        try:
            input_ = type_(input())
        except (ValueError, TypeError):
            if force:
                continue
            return None
        except EOFError:
            print()
            if force:
                continue
            return None
        except KeyboardInterrupt:
            sys.exit("")
        else:
            return input_
        finally:
            sys.stdin = stdin


def print_err(*args, **kwargs):
    """ A wrapper around built-in 'print' function connected to stderr. """
    print(*args, **kwargs, file=sys.stderr)


def error(message: str = "", status: int = 1, fatal: bool = False):
    """
        Prints an error message prepended with "Error: " to stderr.
        If 'fatal' is True, terminates the program with exit status 'status'.
        If 'status' is not an int, exit status is set to 1.

        Args:
            message (str): the message to print (default - "").
            status  (int): system exit status   (default - 1).
            fatal  (bool): toggles termination  (default - False).
    """
    print("Error:", message, file=sys.stderr)
    if fatal:
        if isinstance(status, int):
            sys.exit(status)
        else:
            sys.exit(1)
