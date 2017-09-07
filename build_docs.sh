#!/bin/bash

# Docs by jazzy
# https://github.com/realm/jazzy
# ------------------------------

jazzy \
  --module 'ColorSlider' \
  --source-directory 'ColorSlider' \
  --readme './README.md' \
  --author 'Sachin Patel' \
  --author_url 'https://gizmosachin.com' \
  --github_url 'https://github.com/gizmosachin/ColorSlider' \
  --root-url 'https://gizmosachin.github.io/ColorSlider/docs' \
  --xcodebuild-arguments -scheme,ColorSlider \
  --copyright '© 2017 [Sachin Patel](http://gizmosachin.com).' \

# Jazzy generates a top-level index.html file, delete it
rm index.html

# Open docs in browser
open ./docs/index.html
