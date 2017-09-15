'use strict';

var gulp = require('gulp');
var cssnano = require('gulp-cssnano');
var rename = require('gulp-rename');
var postcss = require('gulp-postcss');
var sourcemaps = require('gulp-sourcemaps');
var autoprefixer = require('autoprefixer');
var minify = require('gulp-minify');

var CSS_DEST = 'public/css/';
var JS_DEST = 'public/js/'

gulp.task('default', function() {
  // place code for your default task here
  return gulp.src(CSS_DEST+'style.css')
        .pipe(sourcemaps.init())
        .pipe(cssnano())
        .pipe(rename({ extname: '.min.css' }))
        .pipe( postcss([ autoprefixer({ browsers: ['last 4 versions'] }) ]) )
        .pipe(sourcemaps.write('.'))
        .pipe(gulp.dest(CSS_DEST));
});

gulp.task('minifyjs', function() {
  gulp.src(JS_DEST+'scripts.js')
    .pipe(minify({
        ext:{
            src:'.js',
            min:'.min.js'
        },
        ignoreFiles: ['.min.js']
    }))
    .pipe(gulp.dest(JS_DEST))
});
