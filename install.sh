#!/bin/bash

usage()
{
    printf '%b'                                                                \
    'Installs packages for coding lessons.\n\n'                                \
                                                                               \
    'Usage:\n'                                                                 \
    '  install [options]\n\n'                                                  \
                                                                               \
    'Options:\n'                                                               \
    '  -a, --all         install all.\n'                                       \
    '  -c, --c           install C packages.\n'                                \
    '  -d, --dot         download and set up dot repository.\n'                \
    '  -f, --fun         install programs for fun.\n'                          \
    '  -h, --help        display a usage message.\n'                           \
    '  -p, --python      install python packages.\n'                           \
    '      --sdk         download and set up scripts from sdk repo.\n'         \
    '      --school      set up scripts and libs from school repo.\n'          \
    '      --sys         download and set up scripts from sys repo.\n\n'       \
                                                                               \
    'Author:\n'                                                                \
    '  Artyom Danilov\n\n'
}

# ---------------------------------------------------------------------------- #
#                               Global Variables                               #
# ---------------------------------------------------------------------------- #

SHORT_OPTS='acdfhp'
LONG_OPTS='all,c,dot,fun,help,python,school,sdk,sys'
GITHUB='https://github.com/defytheflow'

declare -A FLAGS=(
    [all]=0   # -a, --all
    [c]=0     # -c
    [dot]=0   # -d, --dot
    [fun]=0   # -f, --fun
    [py]=0    # -p, --python
    [sdk]=0   #     --sdk
    [schl]=0  #     --school
    [sys]=0   #     --sys
)

declare -A GIT_REPOS=(
    [dot]="$GITHUB/dot.git"
    [sdk]="$GITHUB/sdk.git"
    [sys]="$GITHUB/sys.git"
    [pylib]="$GITHUB/pylib.git"
)

declare -A PY_PACKAGES=(
    [python3]='python3'
    [pip3]='python3-pip'
    [ipython]='ipython'
    [pylint3]='pylint3'
)

PIP_PACKAGES=(ipython)
FUN_PROGS=(figlet lolcat cowsay cmatrix fortune rig)

ESSENTIALS=(git vim tmux tree)
COMPLEMENTS=(howdoi)

# ---------------------------------------------------------------------------- #
#                                  Functions                                   #
# ---------------------------------------------------------------------------- #

install_from_array()
{
    local progs=($@)

    for prog in "${progs[@]}"; do
        printf "%-60s" "  Checking that '$prog' is installed."
        if [[ ! -x $(command -v "$prog") ]]; then
            echo "  Installing '$prog'..."
            yes | sudo apt-get install "$prog"
            clear
        else
            printf '%10s\n' '[ OK ]'
        fi
    done
}

install_from_dict()
{
    local -n progs=$1

    for prog in "${!progs[@]}"; do
        printf "%-60s" "  Checking that '$prog' is installed."
        if [[ ! -x $(command -v "$prog") ]]; then
            echo "  Installing '$prog'..."
            yes | sudo apt-get install "${progs[$prog]}"
            clear
        else
            printf '%10s\n' '[ OK ]'
        fi
    done
}

install_from_repo()
{
    local repo=$1

    echo -e "${repo^^}\n  Downloading '$repo' repositpry from git..."
    git clone "${GIT_REPOS[$repo]}" > /dev/null 2>&1

    echo "  Setting up '$repo'..."
    make --silent --directory=$repo install
    rm -rf $repo
    echo ''
}

# ---------------------------------------------------------------------------- #
#                                  Validation                                  #
# ---------------------------------------------------------------------------- #

# Display a usage message if no options given
if [[ $# -eq 0 ]]; then
    usage
    exit 0
fi

# ---------------------------------------------------------------------------- #
#                                Parse Options                                 #
# ---------------------------------------------------------------------------- #

ARGV=$(getopt -o $SHORT_OPTS -l $LONG_OPTS -- "$@")

if [[ $? -ne 0 ]]; then
    echo "Try 'install -h | --help' for more information." >&2
    exit 1
fi

eval set -- "$ARGV"

# ---------------------------------------------------------------------------- #
#                                Toggle Options                                #
# ---------------------------------------------------------------------------- #

while true; do
    case "$1" in
        -a | --all)
            FLAGS[all]=1    ;;
        -c | --c)
            FLAGS[c]=1      ;;
        -d | --dot)
            FLAGS[dot]=1    ;;
        -f | --fun)
            FLAGS[fun]=1    ;;
        -h | --help)
            usage
            exit 0          ;;
        -p | --python)
            FLAGS[py]=1     ;;
        --sdk)
            FLAGS[sdk]=1    ;;
        --school)
            FLAGS[schl]=1   ;;
        --sys)
            FLAGS[sys]=1    ;;
        --)
            shift
            break           ;;
    esac
    shift
done

# ---------------------------------------------------------------------------- #
#                                  Validation                                  #
# ---------------------------------------------------------------------------- #

# Check internet connection
echo 'Checking your internet connection.'
if ! wget -q --spider https://google.com; then
    echo 'Error: no internet connection' >&2
    exit 1
fi
echo ''

# ---------------------------------------------------------------------------- #
#                                System Update                                 #
# ---------------------------------------------------------------------------- #

# TESTS: ubuntu - OK, wsl - OK
read -rep 'Update system? [y/n]: ' ans
if [[ "$ans" =~ ^[yY]$ ]]; then

    echo 'Updating packages list...'
    yes | sudo apt-get update
    echo 'Upgrading packages...'
    yes | sudo apt-get upgrade
    echo 'Removing no longer needed packages...'
    yes | sudo apt-get autoremove
    echo 'Running dpkg --configure -a'
    # WSL always asks to run this command, without it fails to install
    sudo dpkg --configure -a > /dev/null 2>&1
    clear

fi
echo ''

# ---------------------------------------------------------------------------- #
#                               Default Install                                #
# ---------------------------------------------------------------------------- #

echo 'ESSENTIALS'
install_from_array "${ESSENTIALS[@]}"
echo ''

echo 'COMPLEMENTS'
install_from_array "${COMPLEMENTS[@]}"
echo ''

# ---------------------------------------------------------------------------- #
#                                      c                                       #
# ---------------------------------------------------------------------------- #

# TESTS: ubuntu - OK, wsl - OK
if [[ ${FLAGS[c]} -eq 1 || ${FLAGS[all]} -eq 1 ]]; then

    echo 'C PACKAGES'
    printf "%-60s" "  Checking that 'build-essential' package is insalled."
    if ! dpkg -s build-essential > /dev/null 2>&1; then
        echo "Installing the 'build-essential package'"
        yes | sudo apt-get install build-essential
        clear
    else
        printf "%10s\n" "[ OK ]"
    fi

    echo "  Setting up C 'school' library..."

    # TODO add call to makefile for installation

    sudo ldconfig # So that library changes took place
    echo ''
fi

# ---------------------------------------------------------------------------- #
#                                     dot                                      #
# ---------------------------------------------------------------------------- #

# TESTS: ubuntu - OK, wsl - OK
if [[ ${FLAGS[dot]} -eq 1 || ${FLAGS[all]} -eq 1 ]]; then
    install_from_repo 'dot'
fi

# ---------------------------------------------------------------------------- #
#                                     fun                                      #
# ---------------------------------------------------------------------------- #

# TESTS: ubuntu - OK, wsl - OK
if [[ ${FLAGS[fun]} -eq 1 || ${FLAGS[all]} -eq 1 ]]; then
    echo 'FUN PROGRAMS'
    install_from_array "${FUN_PROGS[@]}"
    echo ''
fi

# ---------------------------------------------------------------------------- #
#                                    python                                    #
# ---------------------------------------------------------------------------- #

# TESTS: ubuntu - OK, wsl - BUG on ipython
if [[ ${FLAGS[py]} -eq 1 || ${FLAGS[all]} -eq 1 ]]; then

    echo 'PYTHON PACKAGES'
    install_from_dict PY_PACKAGES
    echo ''

    echo 'PIP PACKAGES'
    for package in "${PIP_PACKAGES[@]}"; do
        printf "%-60s" "  Checking that '$package' is installed."
        if ! pip3 show "$package" > /dev/null; then
            echo -e "\nInstalling '$package'..."
            pip3 install "$package" > /dev/null
        else
            printf "%10s\n" "[ OK ]"
        fi
    done
    echo ''

    echo "  Setting up Python 'school' library..."
    [[ ! -d "$HOME/.lib" ]] && mkdir "$HOME/.lib"

    git clone "${GIT_REPOS[pylib]}" > /dev/null 2>&1
    cp -i pylib/*.py "$HOME/.lib"
    rm -rf pylib
    echo ''

fi

# ---------------------------------------------------------------------------- #
#                                    school                                    #
# ---------------------------------------------------------------------------- #

# TESTS: ubuntu - OK, wsl - OK
if [[ ${FLAGS[schl]} -eq 1 || ${FLAGS[all]} -eq 1 ]]; then
    echo -e 'SCHOOL\n  Setting up 'school' scripts...'
    sudo cp -f lesson /usr/local/bin  # 'lesson' script
    echo ""
fi

# ---------------------------------------------------------------------------- #
#                                     sdk                                      #
# ---------------------------------------------------------------------------- #

if [[ ${FLAGS[sdk]} -eq 1 || ${FLAGS[all]} -eq 1 ]]; then
    install_from_repo 'sdk'
fi

# ---------------------------------------------------------------------------- #
#                                     sys                                      #
# ---------------------------------------------------------------------------- #

if [[ ${FLAGS[sys]} -eq 1 || ${FLAGS[all]} -eq 1 ]]; then
    install_from_repo 'sys'
fi

echo 'You are good to go!'

exit 0
