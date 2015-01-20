# Scripts

- [ ] diff between two files
- [ ] pdfposter
- [ ] clean dir (delete ~)
- [ ] optical character recognition
- [ ] pdf extract text, extract pictures
- [ ] display mime-type information
- [ ] LaTeX

## Pictures
- [ ] autorotate pictures (apply exif + delete exif rotation)
- [ ] concatenate pictures → video
- [x] rename from exif
- [ ] purge exif
- [ ] display exif information
- [ ] png optimisation

## Videos
- [ ] download subtitle
- [ ] extract audio from video
- [ ] convert video
- [ ] concatenate video
- [ ] send a file to xbmc
- [ ] display exif information

## Fonts
- [ ] → ttf
- [ ] → odf
- [ ] → eot
- [ ] → woff
- [ ] → svg
- [ ] → webfont + css

# Structure

- [ ] videos rotation: if aconv doesn't work try another way
- [ ] check if result is ok
- [ ] dont use extension but mimetype **done in some pdf scripts**
- [ ] what if selection of directory
- [ ] replace `if [ ! $(which $command) ]\nthen` by `if [ ! $(which $command) ]; then` **done in some pdf and fonts scripts**
- [ ] rotation all script in one or depends of type?
- [ ] replace `pwd` by location of file
- [ ] if script is long notify when finished
- [ ] when scripts are same except one variable (rotate 90-180-270 for example) add this parameter in the name of the script (alias with ln -rs is possible but is that really good?) **done in some pictures rotate scripts**
- [ ] sh instead of bash
- [ ] Notifications: use `echo 'message:hello' | zenity --notification --listen` or `notify-send 'hello'` or `printf` or `xdialog` (depends of system)
