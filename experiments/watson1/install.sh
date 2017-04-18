#!/bin/bash

npm install
browserify -t [ babelify --presets [ es2015 react ] ] watson1.jsx > app.js
