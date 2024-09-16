#!/usr/bin/env bash

# Converts all the image files in the current directory to squared images with
# blurry borders added to pad them out to square, irrespective of their
# orientation.


mkdir -p IG                     # Make the directory if it doesn't exist
rm -f IG/*                      # Clear it out if it exists.

for f in "$@"
do
    # This is the magick! :joy:
    #
    # I don't pretend to understand exactly what's happening inside the
    # parentheses, but it looks like it clones the origninal image, increases
    # the size based on whether the image is landscape or portrait, then applies
    # a blur to that image.
    #
    # After it gets back from the parenthetical expression, the original and the
    # cloned image are merged together to create one square image.
    #
    # The blur value determines how much distortion the edges have. The original
    # 0x12 wasn't doing enough for my taste, so I tried a few and come to settle
    # on 0x50.
    #
    # TODO: make the blur value a parameter to the script.
    magick -verbose $f \
        -gravity center \
        \( +clone -splice "%[fx:w<h?h-w:0]x%[fx:h<w?w-h:0]" -blur 0x50 \) \
        +insert -composite \
        IG/$f
done
