# My Nautilus scripts

There is a lot of nautilus scripts all over the web. But a lot of these scripts are not working very well. No check for errors, no dependency error notification,… Some of them only works in nautilus, some others only in nemo… Some of them only works with files that not contained spaces… So I decided to write my own scripts, with functions, with my own rules,…

## I need

* easy way to copy and adapt script for another need
* notifications (dependency errors or mime-type not supported)
* mime-type check with `file --mime-type -b "$input" | cut -d "/" -f2` (or f1 or no cut…) not ~~${arg##*.}~~ or ~~mimetype -bM "$arg"~~)
* all texts in english (translations are difficult to maintain)
* output ≠ input, never erase input!
* utf-8 symbols in script names to be easiest to identify (←↑→↓⇐⇑⇒⇓↕↔↻↶↷…)
* work well in shell as in files managers ⇒ no use of *$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS* or *NEMO* equivalent
* Direct use: No input box to ask how many, which orientation,…

![screenshot](https://raw.githubusercontent.com/yeKcim/my_nautilus_scripts/master/screenshot.png) ![screenshot prompt](https://raw.githubusercontent.com/yeKcim/my_nautilus_scripts/master/screenshot_prompt.png)

## Less as possible

* click
* dependencies
* long texts notifications
* subdirectories of subdirectories of scripts

# Notifications

    ################################################
    #        notification depends of system        #
    ################################################
    function notif { 
        # the script is running in a term
        if [ $(env | grep '^TERM') ]; then printf "\n#### $(basename "$0") notification ####\n  ⇒  $1\n\n"
        # in x, notifications
        else
            if [ $(which notify-send) ]; then notify-send "$1"
            elif [ $(which zenity) ]; then
                echo "message:$1" | zenity --notification --listen &
            elif [ $(which kdialog) ]; then
                kdialog --title "$1" --passivepopup "This popup will disappear in 5 seconds" 5 &
            elif [ $(which xmessage) ]; then xmessage "$1" -timeout 5
            # You don't have notifications? I don't care, I need to tell you something!
            else
                echo "$1" > "$(basename $0)_notif.txt"
            fi
        fi
    }

Example: `notif "Error: \"$arg\" mimetype is not supported"`

## Dependencies check

    ################################################
    #               dependency check               #
    ################################################
    function depend_check {
        for arg
        do
            if [ ! $(which $arg) ]; then
                notif "Error: Could not find \"$arg\" application."
                exit 1
            fi
        done    
    }

Example: `depend_check pdftk convert`


Dependencies check will be done for each mime-type that need different softwares.

## Arguments number check

    # check if input files > 1
    if (( $# <= "1" )); then 
        notif "$# file selected, \"$(basename $0)\" needs at least 2 input files" 
        exit 1
    fi

## Do not overwrite any file

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

## Mimetype errors notification

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
    cd ~/.gnome2/nemo-scripts/
    git clone https://github.com/yeKcim/my_nautilus_scripts.git scripts

Don't forget to chmod +x
