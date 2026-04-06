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

# Function to strip Jekyll Front Matter and run spell check on Markdown
check_md() {
    local file="$1"
    # Use awk to skip lines between the first pair of '---'
    awk 'NR==1 && /^---$/ {in_fm=1; next} in_fm && /^---$/ {in_fm=0; next} !in_fm {print}' "$file" | \
    hunspell $DICT_ARGS -l
}

# Function to run spell check on HTML
check_html() {
    local file="$1"
    hunspell -H $DICT_ARGS -l "$file"
}

ERROR_COUNT=0

echo "Running spell check on Markdown and HTML files..."

# Find relevant files using git ls-files to respect .gitignore
# -c: cached (tracked) files
# -o: others (untracked) files
# --exclude-standard: respect .gitignore and other standard ignore files
while IFS= read -r -d '' file; do
    if [[ "$file" == *.md ]]; then
        errors=$(check_md "$file" | sort -u)
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
done < <(git ls-files -co --exclude-standard -z -- "*.md" "*.html")

if [ $ERROR_COUNT -gt 0 ]; then
    echo -e "\nSpell check failed. Found errors in $ERROR_COUNT file(s)."
    exit 1
else
    echo -e "\nSpell check passed! No errors found."
    exit 0
fi