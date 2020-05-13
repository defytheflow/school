''' Run as a script '''

import sys
import argparse

from .lesson import Lesson
from .constants import SCRIPT, AUTHOR


def main():
    args = get_args()

    try:
        lesson = Lesson('.')  # <-- Try to start a lesson in current directory ?
    except Exception as err:
        print(err, file=sys.stderr)
        sys.exit(1)
    # except bla bla bla bla bla
    else:
        lesson.run_command(args.command)

    sys.exit(0)


def get_args() -> argparse.Namespace:
    ''' Parse and Validate command line arguments. '''
    # Create parser.
    parser = argparse.ArgumentParser(
                        prog=SCRIPT,
                        usage='%(prog)s [option]... <command>',
                        description='Create an environment for a coding lesson',
                        formatter_class=argparse.RawDescriptionHelpFormatter,
                        epilog='Examples:\n  %(prog)s start\n  %(prog)s end\n\n'
                              f'Created by {AUTHOR}')
    # Add positional argument.
    parser.add_argument('command',
                        type=str,
                        choices=('init', 'start', 'end'),
                        action='store',
                        help='name of the command to run')
    # Add option.
    parser.add_argument('-f',
                        '--force',
                        default=False,
                        action='store_true',
                        help='disable warnings')

    return parser.parse_args()


if __name__ == '__main__':
    main()
