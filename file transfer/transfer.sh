#!/bin/bash
# https://github.com/yeKcim/my_nautilus_scripts
# License: GNU General Public License V3, 29 June 2007
# Installation:
    # Nautilus: copy this file in ~/.local/share/nautilus/scripts/ and chmod +x it
    # Nemo:     copy this file in ~/.local/share/nemo/scripts/     and chmod +x it
    # Caja:     copy this file in ~/.config/caja/scripts/          and chmod +x it
# Dependencies: pdftk, img2pdf
# Concatenate multiple pdf in one
IFS="
"
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
################################################
#               dependency check               #
################################################
function depend_check {
    for arg; do
		hash "$arg" 2>/dev/null || { notif >&2 "Error: Could not find \"$arg\" application."; exit 1; }
    done    
}
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
################################################
#      error write rights notifications        #
################################################
function writeout_right_check {
    out=$(readlink -f -- "$1")
    outdir="${out%/*}"
    [[ ! -w "$outdir" ]] && echo "1" || echo "0"
}

################################################
#                    script                    #
################################################
nb_files_check $# 1

depend_check zip
depend_check curl

writeout_error=0; writeout_error_file=""

directory="$(pwd)"
arguments=()
tmp=""


for arg
do
    # input/output
    input=$(readlink -f -- "$arg")
    input_filename=$(basename -- "$input")
    arguments+=("${input##*/}")
done


output=$(do_not_overwrite "$directory/Transfer.sh.zip")
outputlog=$(do_not_overwrite "$directory/Transfer.sh.log")
tmp="$output $outputlog"

    if [[ $(writeout_right_check "$output") == "1" ]]; then
        ((writeout_error++))
        writeout_error_file="$writeout_error_file \"$directory\""
        break
    fi

    

zip -r $output ${arguments[@]} &
	ZIP_PID=$!
	while kill -0 $ZIP_PID ; do
	    echo "Process active"
	    sleep 1
	    done 
    
curl -sD - --upload-file "${output##*/}" https://transfer.sh/"${output##*/}" > "$outputlog" &
	ZIP_PID=$!
	echo $ZIP_PID
		while kill -0 $ZIP_PID ; do
	    echo "Process active"
	    sleep 1
		done

			addr=$(cat ${outputlog}| tail -1)
	to=$(cat ${outputlog}| grep 'x-url-delete')
	
	thunderbird -compose "subject='File transfer',body=%0d%0a%0d%0a%0d%0a%0d%0a%0d%0a%0d%0aDownload%20link:%20${addr}%0d%0a%0d%0a--------------------%0d%0a%0d%0a(%20Deletion%20token%20to%20remove%20file%20from%20server:%20${to##*/}%20)"
	
if [ -n "$tmp" ]; then
    eval rm $tmp # remove tmp files
fi

error_check "$#" "Can't write in output directory" "$writeout_error" "$writeout_error_file"
