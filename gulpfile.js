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

gulp.task('build:css', function() {
  return gulp.src(CSS_DEST+'style.css')
        .pipe(sourcemaps.init())
        .pipe(cssnano())
        .pipe(rename({ extname: '.min.css' }))
        .pipe( postcss([ autoprefixer({ browsers: ['last 4 versions'] }) ]) )
        .pipe(sourcemaps.write('.'))
        .pipe(gulp.dest(CSS_DEST));
});

gulp.task('build:js', function() {
  return gulp.src(JS_DEST+'scripts.js')
    .pipe(minify({
        ext:{
            src:'.js',
            min:'.min.js'
        },
        ignoreFiles: ['.min.js']
    }))
    .pipe(gulp.dest(JS_DEST));
});

// Guil build task to run the CSS & JS Build.
gulp.task('build', gulp.series('build:css', 'build:js'));
