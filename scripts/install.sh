#!/bin/sh

function usage() {
    printf '%b'                                                                \
    'Install packages for coding lessons.\n\n'                                 \
                                                                               \
    'Usage:\n'                                                                 \
    '  install [options]\n\n'                                                  \
                                                                               \
    'Options:\n'                                                               \
    '  -a, --all         install all.\n'                                       \
    '  -c, --c           install C packages.\n'                                \
    '  -h, --help        display this message and exit.\n'                     \
    '  -p, --python      install Python packages.\n'                           \
    '  -s, --school      set up scripts and libs from school repo.\n'
}

__name__='install'
short_opts='achp'
long_opts='all,c,help,python,school'

declare -A flags=(
    [all]=0       # -a, --all
    [c]=0         # -c, --c
    [python]=0    # -p, --python
    [school]=0    # -s, --school
)

# check options.
if [ $# -eq 0 ]; then
    usage  # display usage message.
    exit 0
fi

# parse options.
argv=$(getopt -o ${short_opts} -l ${long_opts} -- "$@")
if [ $? -ne 0 ]; then
    echo "${__name__}: try '${__name__} --help' for more information." >&2
    exit 1
fi
eval set -- "${argv}"

# toggle options.
while true; do
    case "$1" in
        -a | --all)    flags[all]=1    ;;
        -c | --c)      flags[c]=1      ;;
        -h | --help)   usage && exit 0 ;;
        -p | --python) flags[python]=1 ;;
        -s | --school) flags[school]=1 ;;
             --)       shift && break  ;;
    esac
    shift
done

# internet connection.
echo "${__name__}: checking your internet connection..."
if ! wget -q --spider https://google.com; then
    echo "${__name__}: no internet connection" >&2
    exit 1
fi
echo ''

# system update.
read -rep "${__name__}: update system? [y/n]: " ans
if [ "${ans}" = 'y' ]; then
    yes | sudo apt-get update     && \
    yes | sudo apt-get upgrade    && \
    yes | sudo apt-get autoremove && \
    yes | sudo dpkg --configure -a
    clear
fi
echo ''

# -c.
if [ ${flags[c]} -eq 1 ] || [ ${flags[all]} -eq 1 ]; then
    echo -e "${__name__}: setting up c 'school' library..."
fi

# --python.
if [ ${flags[python]} -eq 1 ] || [ ${flags[all]} -eq 1 ]; then
    echo -e "${__name__}: setting up python 'school' library..."
    cp ../lib/python/*.py ~/.local/lib/python3.*/site-packages/
    echo
fi

# --school.
if [ ${flags[school]} -eq 1 ] || [ ${flags[all]} -eq 1 ]; then
    echo "${__name__}: setting up 'school' scripts..."
    cp lesson.sh ~/.local/bin/lesson
    echo
fi

echo "${__name__}: You are good to go!"
