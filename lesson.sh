#!/bin/bash

# Generates a default directory structure for a lesson.
#
# Usage:
#     lesson <num>
#
# Dependencies:
#     ~/.bash_lib

# Import code from ~/.bashlib file
if [[ -f $BASH_LIB ]]; then
	. $BASH_LIB
else
	echo "Unable to find '$BASH_LIB' file. Please install it and run again"
	exit 1
fi

MAX_LESSON_NUM=100
LESSONS_DIR="Lessons"

# Check if <num> argument was given
if [[ $# -ne 1 ]]; then
	error "Missing <num> argument"
fi

# Check if <num> argument is an integer
if [[ ! "$1" =~ ^[0-9]+$ ]]; then
	error "<num> argument must be an integer"
fi

# Check if <num> argument is less than or equal MAX_LESSON_NUM
if [[ ! "$1" -le $MAX_LESSON_NUM ]]; then
	warning "$1 exceed the MAX_LESSON_NUM"
	proceed
fi

# Check if there is already a Lesson with number <num>
if [[ -d $1 ]]; then
	error "Lesson number $(reversed $1) already exists"
	exit 1
fi

# Check if inside of LESSONS_DIR directory
if [[ ! "$(pwd)" =~ .+/$LESSONS_DIR$ ]]; then
	warning "Not inside $(reversed $LESSONS_DIR) directory"
	proceed
fi
# Check if figlet program is installed
if [[ ! -x "$(command -v figlet)" ]]; then
	error "$(reversed "figlet") is not installed. Please install it and run again."
fi

# Check if lolcat program is installed
if [[ ! -x "$(command -v lolcat)" ]]; then
	error "$(reversed "lolcat") is not installed. Please install it and run again."
fi

# Create the Lesson layout
mkdir $1
mkdir $1/Examples
mkdir $1/Exercises
mkdir $1/Theory
mkdir $1/Whiteboard
mkdir $1/Programs
mkdir $1/Homework

figlet "Lesson $1" | lolcat
