#!/bin/bash

###
## Variables
#

# Directory for Resume
resumeDir=$(realpath $(dirname  $0))

# Directory for inputs
inputsDir="$resumeDir/inputs"
outputsDir="$resumeDir/outputs"

# Name of the Resume file
resumeName="Sylvan Smit - Resume - $(date +%Y-%m-%d)"

###
## Create HTML files for each Markdown file
#

for i in "$inputsDir"/*.md; do
  echo $i
  # Get the name of the file, sans extension, for generating HTML file
  resumeBuildName=$(basename "$i" .md)
  # Convert to HTML
  pandoc --section-divs -f markdown -t html5 -o $inputsDir/$resumeBuildName.html $i
done

###
## Join the HTML files into one HTML Resume
#

pandoc --metadata title=" " --standalone -H $inputsDir/resume.css --section-divs -f markdown -t html5 \
-o "$outputsDir/$resumeName.html" \
-A $inputsDir/description.html \
-A $inputsDir/education.html \
-A $inputsDir/experience.html \
-A $inputsDir/skills.html \
$inputsDir/resume.md

###
## Convert the HTML Resume into PDF Resume
#

pandoc -H $inputsDir/resume.tex "$outputsDir/$resumeName.html" -o "$outputsDir/$resumeName.pdf"

###
## References
#

# Convert to HTML
pandoc --section-divs -f markdown -t html5 -o "$inputsDir/references.html" "$inputsDir/references.md"

# Convert HTML to PDF
pandoc -H $inputsDir/resume.tex "$inputsDir/references.html" -o "$outputsDir/Sylvan Smit - References - $(date +%Y-%m-%d).pdf"

###
## Cover Letter
#

# Convert to HTML
pandoc --section-divs -f markdown -t html5 -o "$inputsDir/cover-letter.html" "$inputsDir/cover-letter.md"

# Convert HTML to PDF
pandoc -H $inputsDir/resume.tex "$inputsDir/cover-letter.html" -o "$outputsDir/Sylvan Smit - Cover Letter - $(date +%Y-%m-%d).pdf"
