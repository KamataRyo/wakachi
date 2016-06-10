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
        .pipe sourcemaps.write()
        .pipe gulp.dest './'

gulp.task 'build', ['coffee']

gulp.task 'watch', ['build'], ->
    gulp.watch ['./**/*.coffee', '!gulpfile.coffee'], ['build']
