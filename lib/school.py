"""
    This module consists of useful functions to be used during coding lessons.
"""

import sys
import readline


def get_int(prompt: str="", force: bool=False) -> int:
    """
        Get a line of text from stdin and try to convert it to an int.

        Args:
            prompt (str): the prompt to display
            force (bool): If True, prompts user until gets a valid int value

        Returns:
            int:  if user input can be converted to int
            None: EOF or user input can not be converted to int (force=False)

        Exits on SIGINT
    """
    while True:
        try:
            i = int(input(prompt))
        except ValueError:
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


def get_float(prompt: str="", force: bool=False) -> float:
    """
        Get a line of text from stdin and try to convert it to a float.

        Args:
            prompt (str): the prompt to display
            force (bool): If True, prompts user until gets a valid float value

        Returns:
            float:  if user input can be converted to float
            None:   EOF or user input can not be converted to float (force=False)

        Exits on SIGINT
    """
    while True:
        try:
            f = float(input(prompt))
        except ValueError:
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


def get_string(prompt: str="") -> str:
    """
        Get a line of text from stdin.

        Args:
            prompt (str): the prompt to display

        Returns:
            str:  if user input is not EOF
            None: if user input is EOF

        Exits on SIGINT
    """
    try:
        s = input(prompt)
    except EOFError:
        return None
    except KeyboardInterrupt:
        sys.exit("")
    else:
        return s


def error(message: str="", fatal: bool=False):
    """
        Prints an error message to stderr.

        Args:
            message (str): the message to print
            fatal  (bool): if True, terminates the program with error code 1.
    """
    print("Error:", message, file=sys.stderr)
    if fatal:
        sys.exit(1)
