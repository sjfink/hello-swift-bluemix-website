#!/bin/bash

npm install
browserify -t reactify watson1.jsx > app.js
