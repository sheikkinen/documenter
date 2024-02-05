#!/bin/zsh

# Get the target directory from the first input parameter
target_directory=$1

# Check if the target directory is provided and exists
if [[ -z "$target_directory" || ! -d "$target_directory" ]]; then
    echo "Usage: $0 [target_directory]"
    echo "Please provide a valid directory."
    exit 1
fi

# Create 'working' directory inside the target directory if it doesn't exist
mkdir -p "working"

# Check for .gitignore in the target directory and print a message if it exists
if [[ -f "$target_directory/.gitignore" ]]; then
    echo ".gitignore file found in $target_directory."
else
    echo ".gitignore file not found in $target_directory."
fi

# Empty the current-folder.txt file
echo "" > "working/current-folder.txt"

# Loop through each subdirectory in the target directory
for subdir in "$target_directory"/*; do
    # Check if it's a directory
    if [[ -d "$subdir" ]]; then
        echo "Checking in subdirectory: $subdir"
        # Check for README.md in the subdirectory
        if [[ -f "$subdir/README.md" ]]; then
            echo "Found README.md in $subdir:" >> "working/current-folder.txt"
            cat "$subdir/README.md" >> "working/current-folder.txt"
            echo "\n" >> "working/current-folder.txt"
        fi
    fi
done

# Loop through each file in the target directory
for file in "$target_directory"/*; do
    echo "Processing file: $file"
    # Skip if it's a directory or .gitignore file
    if [[ -d "$file" || "$file" == *".gitignore" ]]; then
        continue
    fi

    # Append filename and its contents to current-folder.txt
    echo "File: $(basename "$file")" >> "working/current-folder.txt"
    cat "$file" >> "working/current-folder.txt"
    echo "\n" >> "working/current-folder.txt"
done

echo "All files in $target_directory have been processed and saved in working/current-folder.txt."
