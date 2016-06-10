gulp       = require 'gulp'
plumber    = require 'gulp-plumber'
sourcemaps = require 'gulp-sourcemaps'
coffee     = require 'gulp-coffee'
uglify     = require 'gulp-uglify'
notify     = require 'gulp-notify'

gulp.task 'coffee', ->
    gulp.src ['./**/*.coffee', '!gulpfile.coffee']
        .pipe plumber errorHandler: notify.onError "Error: <%= error.message %>"
        .pipe sourcemaps.init()
        .pipe coffee()
        # .pipe uglify()
        .pipe gulp.dest './'

gulp.task 'watch', ['coffee'], ->
    gulp.watch ['./**/*.coffee', '!gulpfile.coffee'], ['coffee']
