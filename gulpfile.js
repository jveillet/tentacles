'use strict';

const gulp = require('gulp');
const cssnano = require('gulp-cssnano');
const rename = require('gulp-rename');
const postcss = require('gulp-postcss');
const sourcemaps = require('gulp-sourcemaps');
const autoprefixer = require('autoprefixer');
const minify = require('gulp-minify');
const gulpStylelint = require('gulp-stylelint');

const CSS_DEST = 'public/css/';
const JS_DEST = 'public/js/'

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

// Gulp task to lint the CSS styles in the project.
// It uses Stylelint under the hood.
gulp.task('lint:css', function lintCssTask() {
  return gulp
    .src(['public/css/style.css', '!public/css/**/*.css.map', '!public/css/**/*.min.css'])
    .pipe(gulpStylelint({
      reporters: [
        {formatter: 'verbose', console: true}
      ],
      debug: true,
      failAfterError: true
    }));
});
