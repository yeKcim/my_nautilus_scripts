# My Nautilus scripts

There is a lot of nautilus scripts all over the web. But a lot of these scripts are not working very well. No check for errors, no dependency error notification,… Some of them only works in nautilus, some others only in nemo… Some of them only works with files that not contained spaces… So I decided to write my own scripts, with functions, with my own rules,…

Actually, just few scripts respect my rules (in my own scripts!), but I'm on it. In my defence, my rules evolve as I rewrite my old scripts.

- [x] [fonts scripts](https://github.com/yeKcim/my_nautilus_scripts/tree/master/fonts)
- [x] [pdf scripts](https://github.com/yeKcim/my_nautilus_scripts/tree/master/pdf)
- [ ] [pictures background scripts](https://github.com/yeKcim/my_nautilus_scripts/tree/master/pictures%20background)
- [ ] [pictures rotation scripts](https://github.com/yeKcim/my_nautilus_scripts/tree/master/pictures%20rotation)
- [ ] [pictures scripts](https://github.com/yeKcim/my_nautilus_scripts/tree/master/pictures)
- [ ] [svg convert scripts](https://github.com/yeKcim/my_nautilus_scripts/tree/master/svg%20convert)
- [ ] [svg export scripts](https://github.com/yeKcim/my_nautilus_scripts/tree/master/svg%20%E2%86%92%20bitmap)
- [ ] [videos scripts](https://github.com/yeKcim/my_nautilus_scripts/tree/master/videos)

## I need

* easy way to copy and adapt script for another need
* notifications when there is errors (errors, dependency or mime-type not supported)
* mime-type check with `mimetype -bM "$arg" | cut -d "/" -f2` (or f1 or no cut…) instead of `${arg##*.}`
* all texts in english (translations are difficult to maintain)
* output ≠ input (another way could be `cp "$1" "$1~"`, I will think about it in near future)
* utf-8 symbols in script names to be easiest to identify (←↑→↓⇐⇑⇒⇓↕↔↻↶↷…)
* script have to work well in shell as in files managers

![screenshot](https://raw.githubusercontent.com/yeKcim/my_nautilus_scripts/master/screenshot.png)

## I don't need

* $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS or NEMO equivalent because I need to be file-manager independent
* Input box to ask how many, which orientation,…

## Less as possible

* click
* dependencies
* long texts notifications
* subdirectories of scripts

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

Example:

    notif "Error: \"$arg\" mimetype is not supported"

## Dependencies check

    ################################################
    #               dependency check               #
    ################################################
    function depend_check {
        if [ ! $(which $1) ]; then
            notif "Error: Could not find \"$1\" application."
            exit 1
        fi
    }

Example:

    for depend in pdftk convert # add here all dependencies only with space separator
    do
        depend_check $depend
    done

Dependencies check will be done for each mime-type that need different softwares.

## Arguments number check

    # check if input files > 1
    if (( $# <= "1" )); then 
        notif "$# file selected, \"$(basename $0)\" needs at least 2 input files" 
        exit 1
    fi

## Help check-list (for my own use)

* [Variables shell (fr)](http://michel.mauny.net/sii/variables-shell.html)
* [Structures de contrôle (fr)](http://aral.iut-rodez.fr/fr/sanchis/enseignement/bash/ar01s10.html)
* [Opérateurs de comparaison (fr)](http://abs.traduc.org/abs-fr/ch07s03.html)

## How to copy these files?
    cd ~/.local/share/nautilus
    git clone https://github.com/yeKcim/my_nautilus_scripts.git scripts
