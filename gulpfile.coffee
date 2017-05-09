'use strict'

gulp       = require 'gulp'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'

gulp.task 'browserify', () ->

  return browserify({
    entries: ['./Wakachi.coffee']
  })
    .bundle()
    .pipe source 'jquery-wakachi.js'
    .pipe gulp.dest './'

gulp.task 'build', ['browserify']
