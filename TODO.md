# Structure
- [ ] check if result is ok
- [x] rotation all script in one or depends of type?
- [ ] if script is long notify when finished
- [x] when scripts are same except one variable (rotate 90-180-270 for example) add this parameter in the name of the script
- [ ] sh instead of bash?
- [x] four spaces instead of tab
- [x] check if output already exist, if so, increment name
- [x] if a lot of files have bad mimetype, only display one global notif
- [ ] more checks
    - [ ] rights: read input
    - [ ] if input exists: in shell can input a file that not exist, in nautilus right clic on a file, a process delete file, run the script, what happens?
    - [x] if output already exist (don't overwrite)
    - [ ] if output is done after execution
- [x] [shell double dash](http://linuxfr.org/users/yekcim/journaux/mes-nautilus-scripts#comment-1585344)
- [x] [avoid which](http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script/677212#677212) (thank you #bash@freenode chan)
- [ ] progress bar (pv? dialog?)
- [ ] pdfimages 0.24.5 (ubuntu 14.04) -all option not available…
- [ ] actual ouput write rights check is bad, replace it. no more pwd (if not in prompt). Usage : 1. if in prompt pwd, 2. input dir, 3. $HOME (+notif to explain where is output), 4. /tmp (+notif to explain where is output), 5. Notification to explain that no dir with write has been avalaible
- [ ] some good idea: http://www.omgubuntu.co.uk/2016/07/useful-pack-nautilus-scripts

# Scripts

# Misc scripts
- [ ] diff between two files
- [x] pdfposter
- [x] clean dir (delete ~)
- [x] optical character recognition
- [x] pdf extract text
- [x] pdf extract pictures
- [ ] display mime-type information
- [ ] LaTeX
- [ ] cbr/cbz
- [x] send by mail
- [x] unoconv
- [ ] lowercase → echo TEST | tr A-Z a-z (what about éàïù…)
- [ ] caps → echo test | tr a-z A-Z (what about éàïù…)
- [ ] export-text-to-path for PS, EPS, PDF ou SVG with -T option
- [ ] shnsplit -o flac *.flac -f *.cue -t '%p - %a - %n.%t'

## Pictures
- [x] autorotate pictures (apply exif + delete exif rotation)
- [ ] concatenate pictures → video
- [x] rename from exif
- [x] purge exif
- [ ] display exif information
- [x] png optimisation (optipng,…)
- [x] [progressive jpg](https://coderwall.com/p/ryzmaa/use-imagemagick-to-create-optimised-and-progressive-jpgs)
- [x] extract pictures from odp, odt,…

## Videos
- [ ] download subtitle
- [ ] include subtitle
- [ ] extract audio from video
- [ ] convert video
- [ ] concatenate video (mkvmerge -o out.mkv in…)
- [ ] send a file to kodi, matchstick, chromekey
- [ ] display exif information
- [ ] videos rotation: if aconv doesn't work try another way
- [ ] qtdump SANY0072.MP4 | strings | grep time
- [ ] sbs → anaglyph

## Fonts
- [ ] → ttf
- [ ] → odf
- [x] → eot
- [ ] → woff
- [ ] → svg
- [ ] → webfont + css

## PDF
- [ ] convert -density 170x170 -quality 25 -compress jpeg input.pdf output.pdf # sometimes better than pdftk…

