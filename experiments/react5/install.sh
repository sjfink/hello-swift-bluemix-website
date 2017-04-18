#!/bin/bash

npm install
browserify -t reactify react5.jsx > app.js
