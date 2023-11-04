#!/bin/bash

# Function to scan directories recursively
scan_dir() {
    local dir=$1
    local indent=$2
    local -a subdirs=()

    # Loop through the files and directories in the current directory
    for file in "$dir"/*; do
        # If it's a directory, add to the subdirs array for later processing
        if [ -d "$file" ]; then
            subdirs+=("$file")
        elif [ -f "$file" ]; then
            # If it's a file, add to the table of contents with appropriate indentation
            echo "${indent}- file: $(basename "$file")" >> _tableofcontents.yaml
            echo "${indent}  path: $file" >> _tableofcontents.yaml
        fi
    done

    # Recursively scan subdirectories
    for subdir in "${subdirs[@]}"; do
        # Print the directory name with indentation
        echo "${indent}- directory: $(basename "$subdir")" >> _tableofcontents.yaml
        echo "${indent}  contents:" >> _tableofcontents.yaml
        # Scan the subdirectory with increased indentation
        scan_dir "$subdir" "$indent    "
    done
}

# Start with the $1 directory and no indentation
echo "table_of_contents:" > _tableofcontents.yaml
scan_dir "./$1" "  "

# Output the result
echo "Table of contents generated in _tableofcontents.yaml"
