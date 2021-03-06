#!/bin/bash

usage()
{
    printf "%b"                                                                \
    "Creates an environment for a coding lesson.\n\n"                          \
                                                                               \
    "Usage:\n"                                                                 \
    "  lesson [options] <command>\n\n"                                         \
                                                                               \
    "Arguments:\n"                                                             \
    "  command                      name of the command.\n"                    \
    "  lesson_num                   the lesson number.\n\n"                    \
                                                                               \
    "Options:\n"                                                               \
    "  -f, --force                  disable warnings.\n"                       \
    "  -h, --help                   display this message.\n\n"                 \
                                                                               \
    "Commands:\n"                                                              \
    "  start <lesson_num>           creates the directories and files\n"       \
    "                               for the lesson.\n\n"                       \
                                                                               \
    "  start-next                   same as start, but automatically\n"        \
    "                               calculates <lesson_num>.\n\n"              \
                                                                               \
    "  end <lesson_num>             removes unused directories, displays\n"    \
    "                               stats and pushes to git.\n\n"              \
                                                                               \
    "  end-last                     same as end, but automatically\n"          \
    "                               calculates <lesson_num>.\n\n"              \
                                                                               \
    "  help                         displays a help message.\n\n"              \
                                                                               \
    "Examples:\n"                                                              \
    "  lesson start 1\n"                                                       \
    "  lesson start-next\n"                                                    \
    "  lesson end 1\n"                                                         \
    "  lesson end-last\n\n"                                                    \
                                                                               \
    "Author:\n"                                                                \
    "  Artyom Daniov\n\n"
}

# ---------------------------------------------------------------------------- #
#                               Global Variables                               #
# ---------------------------------------------------------------------------- #

SHORT_OPTS="fh"
LONG_OPTS="force,help"
HELP_MSG="Try: 'lesson -h | --help' for more information"
TIME_STAMP=".lesson_start"
LANGUAGE=""

MAIN_DIR_NAME="Lessons"
MAIN_DIR_ABS_PATH=""
LESSON_DIRS=(examples exercises theory whiteboard programs todo)

declare -A FLAGS=(
    [force]=0  # -f, --force
)

declare -A COMMANDS=(
    [start]=0       # lesson start <lesson_num>
    [start-next]=0
    [end]=0         # lesson end <lesson_num>
    [end-next]=0
)

# ---------------------------------------------------------------------------- #
#                           Gloval variables - start                           #
# ---------------------------------------------------------------------------- #

MAX_LESSON_NUM=100

# ---------------------------------------------------------------------------- #
#                            Global variables - end                            #
# ---------------------------------------------------------------------------- #

STYLE_ERRORS=0
EXERCISES_COMPLETED=0
PROGRAMS_WRITTEN=0

HOURS_=0
MINUTES_=0
SECONDS_=0

MIN_COMMIT_MESSAGE_LENGTH=20

# ---------------------------------------------------------------------------- #
#                                  Functions                                   #
# ---------------------------------------------------------------------------- #

# Return the absolute path of $MAIN_DIR_NAME directory.
detect_main_dir_abs_path()
{
    local abs_path=$(pwd)

    while [[ ! "$abs_path" =~ ^\/.+\/$MAIN_DIR_NAME$ ]]; do
        abs_path=$(dirname "$abs_path")
    done

    echo $abs_path
}

# Returns 0 if $1 'file' has a '.extension' in the end.
has_ext()
{
    local file=$1

    return $( [[ "$file" =~ ^.+\..+$ ]] )
}

# Calculates the lesson number based on $1 'command' (start | end).
calculate_lesson_number()
{
    local command=$1  # start | end
    local lesson_num=$(ls $MAIN_DIR_ABS_PATH | grep -E '[0-9]+' | sort -n | tail -1)

    case $command in
        start)
            lesson_num=$(( lesson_num + 1))
            echo $lesson_num  ;;
        end)
            echo $lesson_num  ;;
    esac
}

# Counts number of files with c, cpp and py extensions.
# Returns the language (c, cpp, python) with highest count.
detect_language()
{
    local lesson_num=$1
    local c=0
    local cpp=0
    local py=0

    for file in $(find $MAIN_DIR_ABS_PATH/$lesson_num -type f -printf "%f\n"); do
        local extension=${file##*.}
        case $extension in
            c)
                c=$(( c + 1 ))     ;;
            cpp)
                cpp=$(( cpp + 1 )) ;;
            py)
                py=$(( py + 1 ))   ;;
        esac
    done

    if [[ $c -gt $cpp && $c -gt $py ]]; then
        echo c
    elif [[ $cpp -gt $c && $cpp -gt $py ]]; then
        echo cpp
    elif [[ $py -gt $c && $py -gt $cpp ]]; then
        echo python
    else
        echo ""
    fi
}

# Just for a nice printing to start and end screens.
print_language()
{
    local language=$1

    case $1 in
        c)
            echo C      ;;
        cpp)
            echo C++    ;;
        python)
            echo Python ;;
    esac
}

# ---------------------------------------------------------------------------- #
#                              Functions - start                               #
# ---------------------------------------------------------------------------- #

# Creates each of LESSON_DIRS directories.
create_lesson_directories()
{
    local lesson_num=$1

    for dir in "${LESSON_DIRS[@]}"; do
        mkdir -p "$MAIN_DIR_ABS_PATH/$lesson_num/$dir"
    done
}

# Displayed at the beggining of lesson.
print_start_screen()
{
    local columns=$(tput cols)

    printf "%0.s-" $(seq 1 "$columns"); echo -e "\n" # upper border

    echoc "Welcome to Lesson #$LESSON_NUM, $(whoami)!\n"
    [[ -n $LANGUAGE ]] && echoc "Language: $(print_language $LANGUAGE)\n"
    echoc "Remember to express your ideas:\n"
    echoc " 1. Correctly\n"
    echoc " 2. Simply\n"
    echoc " 3. Efficiently\n"

    printf "%0.s-" $(seq 1 "$columns")  # lower border
}

# ---------------------------------------------------------------------------- #
#                               Functions - end                                #
# ---------------------------------------------------------------------------- #

# Increases STYLE_ERRORS and prints an error message
# if $1 file doesn't have an extension.
check_extension()
{
    local file=$1

    if ! has_ext "$file"; then
        STYLE_ERRORS=$(( STYLE_ERRORS + 1 ))
        echo "Style Error: '$file' doesn't have an extension." >&2
        echo "Fix: add an extension." >&2
    fi
}

# Increases STYLE_ERRORS and prints an error message if $1 file is empty.
check_emptiness()
{
    local file=$1

    if [[ ! -s $file ]]; then
        STYLE_ERRORS=$(( STYLE_ERRORS + 1 ))
        echo "Style Error: '$file' is empty." >&2
        echo "Fix: remove it." >&2
    fi
}

# If $1 dir is empty -> remove it.
remove_empty_directory()
{
    local dir=$1

    isempty "$dir" && rm -r "$dir"
}

# Increases EXERCISES_COMPLETED | PROGRAMS_WRITTEN depending on $1 mode
# if $2 file type is c, c++ or python
collect_file_stats()
{
    local mode=$1  # exercises | programs
    local file=$2
    local types=("C source" "C++ source" "Python script")

    for type_ in "${types[@]}"; do
        if [[ "$(file "$file")" =~ "$type_" ]]; then
            case $mode in
                exercises)
                    EXERCISES_COMPLETED=$(( EXERCISES_COMPLETED + 1 )) ;;
                programs)
                    PROGRAMS_WRITTEN=$(( PROGRAMS_WRITTEN + 1 ))       ;;
            esac
        fi
    done
}

# Set global variables HOURS_, MINUTES_, SECONDS_ to time that has passed
# since creation if TIME_STAMP file.
collect_time_stats()
{
    local lesson_num=$1
    local time_stamp=$MAIN_DIR_ABS_PATH/$lesson_num/$TIME_STAMP
    local duration=""

    if [[ -f $time_stamp ]]; then
        duration=$(( $(date +%s) - $(stat -c "%Y" "$time_stamp") ))
        HOURS_=$(( duration / 3600 ))
        MINUTES_=$(( duration / 60 - HOURS_ * 60))
        SECONDS_=$(( duration % 60 ))
        rm "$time_stamp"  # Delete a time-stamp file
    fi
}

# Tackle wrong login/password issues.
git_push()
{
    while true; do
        git push && break
        echo ""
    done
}

# Tackle 'bad' commit messages.
git_commit()
{
    while true; do
        read -rep "Enter commit message: " message

        if [[ ${#message} -lt $MIN_COMMIT_MESSAGE_LENGTH ]]; then
            echo "Error: commit message must be at least" \
                 "$MIN_COMMIT_MESSAGE_LENGTH characters long" >&2
            continue
        fi

        break
    done

    echo ""
    git commit -m "$message"
    echo ""
}

# Displayed at the end of lesson.
print_end_screen()
{
    local columns=$(tput cols)

    printf "%0.s-" $(seq 1 "$columns"); echo -e "\n"  # upper border

    echoc "End of lesson #$LESSON_NUM. Goodbye, $(whoami)!\n"
    [[ -n $LANGUAGE ]] && echoc "Language: $(print_language $LANGUAGE)\n"
    echoc "Stats:\n"
    echoc " 1. Lesson took $HOURS_:$MINUTES_:$SECONDS_\n"
    echoc " 2. Exercises completed: $EXERCISES_COMPLETED\n"
    echoc " 3. Programs written: $PROGRAMS_WRITTEN\n"

    printf "%0.s-" $(seq 1 "$columns")  # lower border
}

# ---------------------------------------------------------------------------- #
#                                Parse options                                 #
# ---------------------------------------------------------------------------- #

ARGV=$(getopt -o $SHORT_OPTS -l $LONG_OPTS -- "$@")

if [[ $? -ne 0 ]]; then
    echo "$HELP_MSG" >&2
    exit 1
fi

eval set -- "$ARGV"

# ---------------------------------------------------------------------------- #
#                                Toggle options                                #
# ---------------------------------------------------------------------------- #

while true; do
    case $1 in
        -f | --force)
            FLAGS[force]=1    ;;
        -h | --help)
            usage
            exit 0            ;;
        --)
            shift
            break           ;;
    esac
    shift
done

# ---------------------------------------------------------------------------- #
#                                  Validation                                  #
# ---------------------------------------------------------------------------- #

# Check the <command> is given.
if [[ $# -eq 0 ]]; then
    echo "Error: missing <command> argument" >&2
    echo "$HELP_MSG" >&2
    exit 1
fi

# ---------------------------------------------------------------------------- #
#                                Toggle command                                #
# ---------------------------------------------------------------------------- #

COMMAND=$1; shift

case $COMMAND in

    start)
        if [[ $# -eq 0 ]]; then
            echo "Error: '$COMMAND' missing <lesson_num> argument" >&2
            echo "$HELP_MSG" >&2
            exit 1
        fi
        FLAGS[start]=1           ;;

    start-next | start-next)
        FLAGS[start-next]=1      ;;

    end)
        if [[ $# -eq 0 ]]; then
            echo "Error: '$command' missing <lesson_num> argument" >&2
            echo "$HELP_MSG" >&2
            exit 1
        fi
        FLAGS[end]=1             ;;

    end-last | finish-last)
        FLAGS[end-last]=1        ;;

    help)
        usage
        exit 0                   ;;

    *)
        echo "Error: unknown command '$1'" >&2
        echo "$HELP_MSG" >&2
        exit 1                   ;;
esac

# ---------------------------------------------------------------------------- #
#                                  Validation                                  #
# ---------------------------------------------------------------------------- #

# Check if inside of MAIN_DIR_NAME directory
if [[ ! "$(pwd)" =~ ^\/.+\/$MAIN_DIR_NAME\/?.*$ ]]; then
    echo "Error: Not inside '$MAIN_DIR_NAME' directory." >&2
    echo $HELP_MSG >&2
    exit 1
else
    MAIN_DIR_ABS_PATH=$(detect_main_dir_abs_path)
fi

# ---------------------------------------------------------------------------- #
#                            start-next | end-last                             #
# ---------------------------------------------------------------------------- #

if [[ ${FLAGS[start-next]} -eq 1 ]]; then

    LESSON_NUM=$(calculate_lesson_number "start")

    # ----------------------------------------------------------- #
    #                         Validation                          #
    # ----------------------------------------------------------- #

    # If we have a previous lesson
    if [[ $LESSON_NUM -gt 1 ]]; then
        LANGUAGE=$(detect_language $(( LESSON_NUM - 1 )))
    fi

    FLAGS[start]=1

elif [[ ${FLAGS[end-last]} -eq 1 ]]; then

    LESSON_NUM=$(calculate_lesson_number "end")

    # ----------------------------------------------------------- #
    #                         Validation                          #
    # ----------------------------------------------------------- #

    # If running end-last command on an empty directory.
    if [[ -z $LESSON_NUM ]]; then
        echo "Error: no previous lesson found." >&2
        echo "Fix: try 'lesson start-next'." >&2
        exit 1
    fi

    LANGUAGE=$(detect_language $LESSON_NUM)
    FLAGS[end]=1

elif [[ ${FLAGS[start]} -eq 1 ]]; then
    LESSON_NUM=${1##*/}  # remove parent directory names
    if [[ $LESSON_NUM -gt 1 ]]; then
        LANGUAGE=$(detect_language $(( LESSON_NUM - 1 )))
    fi

elif [[ ${FLAGS[end]} -eq 1 ]]; then
    LESSON_NUM=${1##*/}  # remove parent directory names
    LANGUAGE=$(detect_language $LESSON_NUM)
fi

shift

# ---------------------------------------------------------------------------- #
#                                  Validation                                  #
# ---------------------------------------------------------------------------- #

# Check if <lesson_num> argument is a positive number
if [[ ! "$LESSON_NUM" =~ ^[0-9]+$ ]]; then
    echo "Error: <lesson_num> argument must be an integer" >&2
    echo "Fix: Try 1..$MAX_LESSON_NUM" >&2
    exit 1
fi

# Check if <lesson_num> argument is less than or equal MAX_LESSON_NUM
if [[ ! "$LESSON_NUM" -le $MAX_LESSON_NUM ]]; then
    if [[ ${FLAGS[force]} -ne 1 ]]; then
        echo "Warning: $LESSON_NUM exceeds the MAX_LESSON_NUM"
        echo "It may affect how I work"
        read -rep "Proceed? [y/n]: " ans
        [[ ! "$ans" =~ ^[yY]$ ]] && exit 0
    fi
fi

# ---------------------------------------------------------------------------- #
#                                    start                                     #
# ---------------------------------------------------------------------------- #

if [[ ${FLAGS[start]} -eq 1 ]]; then

    # ----------------------------------------------------------- #
    #                         Validation                          #
    # ----------------------------------------------------------- #

    # Check if there is a Lesson with number <lesson_num>
    if [[ -d $MAIN_DIR_ABS_PATH/$LESSON_NUM ]]; then
        echo "Error: Lesson number '$LESSON_NUM' already exists" >&2
        echo "Fix: Try another number" >&2
        exit 1
    fi

    create_lesson_directories "$LESSON_NUM"

    touch "$MAIN_DIR_ABS_PATH/$LESSON_NUM/$TIME_STAMP"  # Create a time-stamp file

    print_start_screen

# ---------------------------------------------------------------------------- #
#                                     end                                      #
# ---------------------------------------------------------------------------- #

elif [[ ${FLAGS[end]} -eq 1 ]]; then

    # ----------------------------------------------------------- #
    #                         Validation                          #
    # ----------------------------------------------------------- #

    # Check if there is no lesson with number <lesson_num>
    if [[ ! -d $MAIN_DIR_ABS_PATH/$LESSON_NUM ]]; then
        echo "Error: Lesson number '$LESSON_NUM' doesn't exist" >&2
        exit 1
    fi

    ## ANALYZE EACH DIRECTORY

    for dir in "${LESSON_DIRS[@]}"; do  # for each directory
        full_dir="$MAIN_DIR_ABS_PATH/$LESSON_NUM/$dir"

        if [[ -d $full_dir ]]; then  # if directory exists

            for file in $(ls "$full_dir"); do  # for each file in directory
                full_file="$MAIN_DIR_ABS_PATH/$LESSON_NUM/$dir/$file"

                check_extension "$full_file"
                check_emptiness "$full_file"

                case $dir in
                    exercises | programs)
                        collect_file_stats "$dir" "$full_file" ;;
                esac
            done

            remove_empty_directory "$full_dir" # empty
        fi
    done

    [[ $STYLE_ERRORS -gt 0 ]] && exit 1 # Exit if have 'style' errors

    collect_time_stats "$LESSON_NUM"

    # If git repo and changes were made
    if git status > /dev/null 2>&1 && [[ -n $(git status --porcelain) ]]; then
        git status; echo ""
        git add .
        git_commit
        git_push
    fi

    print_end_screen

    if isempty "$MAIN_DIR_ABS_PATH/$LESSON_NUM"; then
        rmdir "$MAIN_DIR_ABS_PATH/$LESSON_NUM"
    else
        tree "$MAIN_DIR_ABS_PATH/$LESSON_NUM"
    fi

fi

exit 0
