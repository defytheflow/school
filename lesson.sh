#!/bin/bash

# Generates a default directory structure for a lesson.
#
# Usage:
#     lesson <num>

# Variable Definitions

MAX_LESSON_NUM=100
LESSONS_DIR="Lessons"

# Function Definitions

# Prompt user if to proceed or not. 
proceed() {
	echo -n "Proceed? [y/n]: "
	read ANS
	if [[ ! "$ANS" =~ ^[yY][eE]?[sS]?$ ]]; then
			exit 0
	fi
}

# Returns text highlighted with white background
reversed() {
	echo "\033[7m$1\033[0m"
}

# Returns text in green color
green() {
	echo "\033[0;32m$1\033[0m"
}

# Reports an error in red color and exits the program
error() {
	printf "\033[1;31mError:\033[0m $1\n"
	exit 1
}

# Reports a warning in yellow
warning() {
	printf "\033[1;33mWarning:\033[0m $1\n"
}

# Main part of the Script

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
