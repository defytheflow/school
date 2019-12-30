#!/bin/bash

# Generates a default directory structure for a lesson.
#
# Usage:
# 	lesson <num>

RED="\033[1;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NO_COLOR="\033[0m"

# Check if a <num> argument was given
if [[ $# -ne 1 ]]; then
	printf "${YELLOW}Usage:${NO_COLOR} lesson <num>\n"
	exit 1
fi

# Check if a <num> argument is an integer
if [[ !  "$1" =~ ^[0-9]+$ ]]; then
	printf "${RED}Error:${NO_COLOR} <num> argument must be an integer\n"
	exit 1
fi

# Check if there is already a Lesson with number <num>
if [[ -d $1 ]]; then
	printf "${RED}Error:${NO_COLOR} Lesson $1 already exists\n"
	exit 1
fi

# Create the Lesson layout
mkdir $1
mkdir $1/Examples
mkdir $1/Exercises
mkdir $1/Theory
mkdir $1/Whiteboard
mkdir $1/Programs
mkdir $1/Homework

printf "${GREEN}Done!${NO_COLOR} Let's learn now!\n"
