# My Nautilus scripts

There is a lot of nautilus scripts all over the web. But a lot of these scripts are not working very well. No check for errors, no dependency error notification,… Some of them only works in nautilus, some others only in nemo… Some of them only works with files that not contained spaces… So I decided to write my own scripts, with functions, with my own rules,…

## I need

* easy way to copy and adapt script for another need
* notifications (write access error, dependency errors or not supported mime-type)
* mime-type check with `file --mime-type -b "$input" | cut -d "/" -f2` (or f1 or no cut…) not ~~${arg##*.}~~ or ~~mimetype -bM "$arg"~~)
* all texts in english (translations are difficult to maintain)
* output ≠ input, never erase input!
* utf-8 symbols in script names to be easiest to identify (←↑→↓⇐⇑⇒⇓↕↔↻↶↷…)
* work well in shell as in files managers ⇒ no use of *$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS* or *NEMO* equivalent
* Direct use: No input box to ask how many, which orientation,…

![screenshot](https://raw.githubusercontent.com/yeKcim/my_nautilus_scripts/master/screenshot.png) ![screenshot2](https://raw.githubusercontent.com/yeKcim/my_nautilus_scripts/master/screenshot2.png) ![screenshot prompt](https://raw.githubusercontent.com/yeKcim/my_nautilus_scripts/master/screenshot_prompt.png)

## Less as possible

* click
* dependencies
* very long texts notifications
* subdirectories of subdirectories of scripts

## Some functions

### Notifications

    ################################################
    #        notification depends of system        #
    ################################################
    function notif { 
        # the script is running in a term
        if [ $(env | grep '^TERM') ]; then printf "\n#### $(basename -- "$0") notification ####\n  ⇒  $1\n\n"
        else # in x, notifications
		    if   hash notify-send 2>/dev/null; then notify-send "$1"
		    elif hash zenity 2>/dev/null; then { echo "message:$1" | zenity --notification --listen & }
		    elif hash kdialog 2>/dev/null; then { kdialog --title "$1" --passivepopup "This popup will disappear in 5 seconds" 5 & }
		    elif hash xmessage 2>/dev/null; then xmessage "$1" -timeout 5
            else echo "$1" > "$(basename -- $0)_notif.txt"
            fi
        fi
    }

Example: `notif "Error: \"$arg\" mimetype is not supported"`

### Dependencies check

    ################################################
    #               dependency check               #
    ################################################
    function depend_check {
        for arg; do
		    hash "$arg" 2>/dev/null || { notif >&2 "Error: Could not find \"$arg\" application."; exit 1; }
        done    
    }

Example: `depend_check pdftk convert`

Dependencies check will be done for each mime-type that need different softwares if needed. If not check at the begining of script

### Do not overwrite any file

    ################################################
    #         do not overwrite with output         #
    ################################################
    function do_not_overwrite {
        out="$1"
        while [[ -a "$out" ]]; do
            when=$(date +%Y%m%d-%H:%M:%S)
            [[ -f "$out" ]] && out="${out%.*}#$when.${out##*.}" || out="$out#$when"
        done
        echo "$out"
    }

Example: `output_dir=$(do_not_overwrite "${input_filename}_explode")`

### Check if user has selected enough files

    ################################################
    #          check if input files > min          #
    ################################################
    function nb_files_check {
        nb_files="$1"
        min_nb_files="$2"
        if (( $1 < $2 )); then 
            [[ $2 == 1 ]] && notif "$1 file selected, \"$(basename -- $0)\" needs at least one input file" || notif "$1 file selected, \"$(basename -- $0)\" needs at least $2 input files" 
            exit 1
        fi 
    }

Example: `nb_files_check $# 2` for a script that need at least 2 inputs

### Errors notification

Avoid multiple notifications for mimetype errors:

    ################################################
    #              error notifications             #
    ################################################
    function error_check {
        nb_files="$1"
        error_message="Error: $2"
        nb_error="$3"
        name_error_files="$4"

        if [[ $nb_error != 0 ]]; then
            [[ $nb_error == 1 ]] && error_message="$error_message:$name_error_files"
            [[ $nb_error > 1 ]] && [[ $nb_error < $nb_files ]] && error_message="$error_message ($nb_error/$nb_files files: $name_error_files)"
            [[ $nb_error > 1 ]] && [[ $nb_error = $nb_files ]] && error_message="$error_message (All selected files)"
        notif "$error_message"
        fi
    }

Example: `error_check "$#" "Mimetype not supported" "$mime_error" "$mime_error_file"`

Avoid multiple notifications for write output directory errors:

    ################################################
    #      error write rights notifications        #
    ################################################
    function writeout_right_check {
        out=$(readlink -f -- "$1")
        outdir="${out%/*}"
        [[ ! -w "$outdir" ]] && echo "1" || echo "0"
    }

In the loop:

    if [[ $(writeout_right_check "$output_dir") == "1" ]]; then
        ((writeout_error++))
        writeout_error_file="$writeout_error_file \"$input_filename\""
        continue
    fi
    
At the end of file use `error_check`

### Trash instead of rm

Some scripts use `rm` for temp files i don't care about these but some other use `rm -f` for a lot of files ([clean backup files (*~)](https://github.com/yeKcim/my_nautilus_scripts/blob/master/files%20manager/clean%20backup%20files%20%28*~%29) for example). Some people don't like `rm -f` in script, so i can use `trash` command. As I don't need to be `trash-cli` dependent (I need that my script work without ′trash-cli′ package), I write: 

    hash "trash" 2>/dev/null && commandrm="trash" || { notif >&2 "If you don't like rm command in script, install trash (trash-cli package)."; commandrm="rm"; }

### Not used: output directory ###

I've create a function to find a directory with write access in case that default one hasn't. Will I use it? Don't know…

    ################################################
    #                  outputdir                   #
    ################################################
    function defineoutputdir {                                          # the_inputfile or the inputdirectory
        out=$(readlink -f -- "$1")
        outdir="${out%/*}"                                              # if not in shell, default output directory is input one
        redir=0
        if [ $(env | grep '^TERM') ]; then                              # if in shell, default output directory is pwd
            [[ -w "$(pwd)" ]] && outdir="$(pwd)" && redir=0 || redir=1  # if no write access to pwd, output is input directory
        fi
        [[ ! -w "$outdir" ]] && outdir="$HOME/" && redir=1              # if no write access to default dir, output is home dir
        [[ ! -w "$outdir" ]] && outdir="/tmp/"  && redir=1              # if no write access to default dir or ~, output is /tmp
        [[ ! -w "$outdir" ]] && outdir=""       && redir=2              # if no write access to default dir or ~ or /tmp ⇒ wtf?
        echo $outdir
        return $redir                                                   # 0 if default outdir, 1 if redirect, 2 if no write access
    }
    
    odir=$(defineoutputdir "$1")                                        # odir = output directory
    odir_redir=$?  


## Help check-list (for my own use)

* [Variables shell (fr)](http://michel.mauny.net/sii/variables-shell.html)
* [Structures de contrôle (fr)](http://aral.iut-rodez.fr/fr/sanchis/enseignement/bash/ar01s10.html)
* [Opérateurs de comparaison (fr)](http://abs.traduc.org/abs-fr/ch07s03.html)
* [Quelques bonnes pratiques](http://ineumann.developpez.com/tutoriels/linux/bash-bonnes-pratiques/)


## How to copy these files…

### … in nautilus?
    cd ~/.local/share/nautilus
    git clone https://github.com/yeKcim/my_nautilus_scripts.git scripts

### … in nemo?
    cd ~/.local/share/nemo/scripts/
    git clone https://github.com/yeKcim/my_nautilus_scripts.git scripts
    
### … in caja?
    cd ~/.config/caja/scripts/
    git clone https://github.com/yeKcim/my_nautilus_scripts.git scripts

Don't forget to chmod +x
