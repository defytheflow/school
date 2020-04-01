#!/usr/bin/python3

import os
import sys
import argparse

import typing
CmdLineArgs = typing.NewType('CmdLineArgs', argparse.Namespace)

# Local.
import const
import utils

import start
import end


def main():
    ''' Entry point. '''
    args = get_args()

    if not os.path.isdir(os.path.join(os.getcwd(), const.LESSON_DIR)):
        utils.err('Not inside lesson tracked directory.\n')
        sys.exit(1)

    if args.command == 'start':
        start.main()

    elif args.command == 'end':
        end.main()

    sys.exit(0)


def get_args() -> CmdLineArgs:
    ''' Parse and Validate command line arguments. '''
    # Create parser.
    parser = argparse.ArgumentParser(
                        prog=const.SCRIPT,
                        usage='%(prog)s [option]... <command>',
                        description='Create an environment for a coding lesson',
                        formatter_class=argparse.RawDescriptionHelpFormatter,
                        epilog='Examples:\n  %(prog)s start\n  %(prog)s end\n\n'
                              f'Created by {const.AUTHOR}')
    # Add positional argument.
    parser.add_argument('command',
                        type=str,
                        choices=('start', 'end'),
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
