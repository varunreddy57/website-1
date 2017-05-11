gulp = require 'gulp'
connect = require 'gulp-connect'
sass = require 'gulp-sass'
autoprefixer = require 'gulp-autoprefixer'
pug = require 'gulp-pug'
plumber = require 'gulp-plumber'
sourcemaps = require 'gulp-sourcemaps'
cssmin = require 'gulp-cssnano'
rename = require 'gulp-rename'
notify = require 'gulp-notify'
uglifyjs = require 'gulp-uglifyjs'
chokidar = require 'chokidar'

prod = ''
dev = ''

gulp.task 'connect', ->
  connect.server
    port: 3088
    livereload: on
    root: prod

gulp.task 'js', ->
  gulp.src [dev + 'js/custom/*.js']
    .pipe plumber()
    .pipe uglifyjs('scripts.min.js').on 'error', notify.onError({
    title: 'JS: FAIL'
    message: 'Error: <%= error.message %>'
  })
    .pipe plumber.stop()
    .pipe gulp.dest prod + 'js'
    .pipe notify ({
    title: 'Sass: SUCCESS'
    message: 'Generated file: <%= file.relative %>'
  })

gulp.task 'sass', ->
  gulp.src [dev + 'scss/*.+(sass|scss)', '!' + dev + 'scss/_*.+(sass|scss)']
    .pipe plumber()
    .pipe sass({
    outputStyle: 'compressed'
    errLogToConsole: true
  }).on 'error', notify.onError({
    title: 'SASS: FAIL'
    message: 'Error: <%= error.message %>'
  })
    .pipe sourcemaps.write()
    .pipe plumber.stop()
    .pipe gulp.dest dev + 'css'
    .pipe notify({
    title: 'Sass: SUCCESS'
    message: 'Generated file: <%= file.relative %>'
  })

gulp.task 'sass-dev', ->
  gulp.src [dev + 'scss/*.+(sass|scss)', '!' + dev + 'scss/_*.+(sass|scss)']
    .pipe plumber()
    .pipe sourcemaps.init()
    .pipe sass({
    outputStyle: 'expanded'
    errLogToConsole: true
  }).on 'error', notify.onError({
    title: 'SASS dev: FAIL'
    message: 'Error: <%= error.message %>'
  })
    .pipe sourcemaps.write()
    .pipe plumber.stop()
    .pipe gulp.dest dev + 'css'
    .pipe notify({
    title: 'Sass: SUCCESS'
    message: 'Generated file: <%= file.relative %>'
  })

gulp.task 'css', ->
  gulp.src [dev + 'css/*.css', '!' + dev + 'css/*.min.css']
    .pipe autoprefixer()
    .pipe rename({suffix: '.min'})
    .pipe cssmin()
    .pipe gulp.dest prod + 'css'

gulp.task 'pug', ->
  gulp.src [dev + 'pug/*.pug', '!' + dev + 'pug/_*.pug']
    .pipe plumber()
    .pipe pug({
    pretty: true,
    errLogToConsole: pug.logError
  }).on 'error', notify.onError({
    title: 'Pug: FAIL'
    message: 'Error: <%= error.message %>'
  })
    .pipe plumber.stop()
    .pipe gulp.dest prod
    .pipe notify({
    title: 'Pug: SUCCESS'
    message: 'Generated file: <%= file.relative %>'
  })

gulp.task 'reload', ->
  gulp.src '*.*'
    .pipe do connect.reload

gulp.task 'watch', ->
  gulp.watch [dev + 'scss/*.+(sass|scss)',
    dev + 'scss/**/*.+(sass|scss)'], ['sass']
  gulp.watch [dev + 'js/custom/*.js'], ['js']
  gulp.watch [dev + 'css/*.css', dev + 'css/**/*.css',
    '!' + dev + 'css/*.min.css', '!' + dev + 'css/**/*.min.css'], ['css']
  gulp.watch [dev + 'pug/*.pug', dev + 'pug/**/*.pug'], ['pug']
  gulp.watch [prod + '*.*', prod + '**/*.*', prod + '*.html',
    '!' + dev + 'scss/*.+(sass|scss)', '!' + dev + 'scss/**/*.+(sass|scss)',
    '!gulpfile.*', '!' + dev + 'pug/*.pug',
    '!' + dev + 'pug/**/*.pug'], {awaitWriteFinish: true}, ['reload']

gulp.task 'default', ['js', 'sass', 'css', 'pug', 'connect']
gulp.task 'dev', ['js', 'sass-dev', 'css', 'pug', 'connect', 'watch']
