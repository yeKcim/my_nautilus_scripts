# Scripts

- [ ] diff between two files
- [ ] pdfposter
- [ ] clean dir (delete ~)
- [ ] optical character recognition
- [ ] pdf extract text, extract pictures
- [ ] display mime-type information
- [ ] LaTeX
- [ ] cbr/cbz

## Pictures
- [ ] autorotate pictures (apply exif + delete exif rotation)
- [ ] concatenate pictures → video
- [x] rename from exif
- [ ] purge exif
- [ ] display exif information
- [ ] png optimisation (optipng,…)
- [ ] [progressive jpg](https://coderwall.com/p/ryzmaa/use-imagemagick-to-create-optimised-and-progressive-jpgs)

## Videos
- [ ] download subtitle
- [ ] extract audio from video
- [ ] convert video
- [ ] concatenate video
- [ ] send a file to xbmc
- [ ] display exif information
- [ ] videos rotation: if aconv doesn't work try another way

## Fonts
- [ ] → ttf
- [ ] → odf
- [ ] → eot
- [ ] → woff
- [ ] → svg
- [ ] → webfont + css

# Structure
- [ ] check if result is ok
- [ ] replace `if [ ! $(which $command) ]\nthen` by `if [ ! $(which $command) ]; then` **done in some pdf and fonts scripts**
- [ ] rotation all script in one or depends of type?
- [ ] if script is long notify when finished
- [ ] when scripts are same except one variable (rotate 90-180-270 for example) add this parameter in the name of the script (alias with ln -rs is possible but is that really good?) **done in some pictures rotate scripts**
- [ ] sh instead of bash?
- [ ] four spaces instead of tab
- [ ] check if output already exist, if so, increment name
- [ ] if a lot of files have bad mimetype, only display one global notif
