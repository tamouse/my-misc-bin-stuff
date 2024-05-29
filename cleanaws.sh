#!/usr/bin/env sh

# One day ( 2024.05.29.) I screwed an uploade to AWS S3, and had
# to get rid of the dang files.

set -evx

for f in \
    "Art/ink-and-paper/2024.04.10.Theos2024BirthdayCard-sketch.jpg" \
    "Art/ink-and-paper/2024.04.10.Theos2024BirthdayCard-sketch.pdf" \
    "Art/ink-and-paper/2024.05.29.Theos2024BirthdayCard.front&back.1-front.jpg" \
    "Art/ink-and-paper/2024.05.29.Theos2024BirthdayCard.front&back.2-back.jpg" \
    "Art/ink-and-paper/2024.05.29.Theos2024BirthdayCard.front&back.pdf"; do

    aws s3 rm "s3://tt-archive/$f"
done
