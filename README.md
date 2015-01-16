# My Nautilus scripts

I don't want $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS or NEMO equivalent in my scripts because i need a universal solution

## Less as possible

* click
* dependencies
* long texts notifications

## I need

* easy way to copy and adapt script for another need
* notifications when there is errors (dependency or 
* mime-type check with `mimetype -bM "$arg" | cut -d "/" -f2` instead of `${arg##*.}`
* all texts in english (translations are difficult to maintain)

## dependencies

If the script works well with only one command for all mime-type, we could probably check for dependencies with this kind of code at the beginning of the script:

    if [ ! $(which the_name_of_dependency) ]; then
        notify-send "Error: Could not find \"the_name_of_dependency\" application."
        exit 1
	fi

Eventually, if there is more than one dependency :

    for command in the_name_of_first_dependency the_name_of_second_dependency  # add here all dependencies only with space separator
        do
            if [ ! $(which $command) ]; then
                notify-send "Error: Could not find \"$command\" application."
                exit 1
            fi
        done

But, i need that all my nautilus script have the same structure (easiest to copy+modify to adapt to another need). So dependencies check will be done for each mime-type that need different softwares.
