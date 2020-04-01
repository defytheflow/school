#!/usr/bin/python3

''' '''

import sys
import argparse

import const


def main():
    ''' Entry point. '''
    args = get_args()
    print(args)
    sys.exit(0)


def get_args():
    ''' Parse and Validate command line arguments. '''
    # Create parser.
    parser = argparse.ArgumentParser(
                        prog=const.SCRIPT,
                        usage='%(prog)s [option]... <command>',
                        description='Create an environment for a coding lesson',
                        epilog=f'Created by {const.AUTHOR}')
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
