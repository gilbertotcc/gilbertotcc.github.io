#!/usr/bin/env bash

set -e

# Ensure hunspell is installed
if ! command -v hunspell &> /dev/null; then
    echo "Error: hunspell is not installed."
    echo "Please install it (e.g., 'brew install hunspell' or 'sudo apt-get install hunspell')."
    exit 1
fi

# Define custom dictionary path
DICT_ARGS="-d ./hunspell/custom,en_GB"

# Function to strip Jekyll/Astro Front Matter
strip_front_matter() {
    local file="$1"
    # Use awk to skip lines between the first pair of '---'
    awk 'NR==1 && /^---$/ {in_fm=1; next} in_fm && /^---$/ {in_fm=0; next} !in_fm {print}' "$file"
}

# Function to run spell check on Markdown (stripping code blocks)
check_md() {
    local file="$1"
    strip_front_matter "$file" | \
    sed -e '/^```/,/^```/d' -e 's/`[^`]*`//g' | \
    hunspell $DICT_ARGS -l
}

# Function to run spell check on Astro (stripping scripts, styles, and curly expressions)
check_astro() {
    local file="$1"
    strip_front_matter "$file" | \
    sed -e '/<script/,/<\/script>/d' -e '/<style/,/<\/style>/d' -e 's/{[^}]*}//g' | \
    hunspell -H $DICT_ARGS -l
}

# Function to run spell check on HTML
check_html() {
    local file="$1"
    hunspell -H $DICT_ARGS -l "$file"
}

ERROR_COUNT=0

echo "Running spell check on Markdown, HTML, and Astro files (ignoring code snippets)..."

# Find relevant files using git ls-files to respect .gitignore
while IFS= read -r -d '' file; do
    if [[ "$file" == *.md ]]; then
        errors=$(check_md "$file" | sort -u)
    elif [[ "$file" == *.astro ]]; then
        errors=$(check_astro "$file" | sort -u)
    elif [[ "$file" == *.html ]]; then
        errors=$(check_html "$file" | sort -u)
    else
        continue
    fi

    if [ -n "$errors" ]; then
        echo -e "\nMisspelled words in: $file"
        echo "$errors"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
done < <(git ls-files -co --exclude-standard -z -- "*.md" "*.html" "*.astro")

if [ $ERROR_COUNT -gt 0 ]; then
    echo -e "\nSpell check failed. Found errors in $ERROR_COUNT file(s)."
    exit 1
else
    echo -e "\nSpell check passed! No errors found."
    exit 0
fi
