"""
    This module consists of useful functions to be used during coding lessons.
"""

import sys


def get_int(prompt: str="") -> int:
    """
        Get a line of text from stdin and try to convert it to an int.

        Args:
            prompt (str): the prompt to display

        Returns:
            int:  if user input can be converted to int
            None: EOF or user input can not be converted to int

        Exits on SIGINT
    """
    try:
        num = int(input(prompt))
    except (ValueError, EOFError):
        return None
    except KeyboardInterrupt:
        sys.exit("")
    else:
        return num


def get_float(prompt: str="") -> float:
    """
        Get a line of text from stdin and try to convert it to a float.

        Args:
            prompt (str): the prompt to display

        Returns:
            float:  if user input can be converted to float
            None:   EOF or user input can not be converted to float

        Exits on SIGINT
    """
    try:
        num = float(input(prompt))
    except (ValueError, EOFError):
        return None
    except KeyboardInterrupt:
        sys.exit("")
    else:
        return num


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
        string = input(prompt)
    except EOFError:
        return None
    except KeyboardInterrupt:
        sys.exit("")
    else:
        return string
