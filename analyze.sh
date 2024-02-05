#!/bin/zsh

# Check if exactly one argument is given
if [[ $# -ne 1 ]]; then
    echo "Usage: ./analyze.sh target_directory"
    exit 1  # Exit with a non-zero status to indicate an error
fi

# Source the environment variables
source env.sh

# Define the target directory
target_directory=$1

# Dump the target directory
./dump-folder.sh "$target_directory"

# Check if current-folder.txt exists in the target directory
if [[ ! -f "working/current-folder.txt" ]]; then
    echo "current-folder.txt not found in the specified directory."
    exit 1
fi

# Function to escape special characters for JSON
escape_for_json() {
    sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\x08/\\b/g' -e 's/\x0c/\\f/g' -e 's/\x0a/\\n/g' -e 's/\x0d/\\r/g' -e 's/\x09/\\t/g'
}

# Prepare the data for OpenAI API call
{
    echo "{"
    echo "  \"model\": \"gpt-3.5-turbo-0125\","
    # gpt-4-1106-preview
    echo "  \"messages\": ["
    echo "    {"
    echo "      \"role\": \"system\","
    echo "      \"content\": \"As a senior developer, analyze the following folders and files and create a README.md file using markdown syntax. Include summary of subfolders utilizing README files from them. Summary level, no repeating of code or json.\""
    echo "    },"
    echo "    {"
    echo "      \"role\": \"user\","
    echo -n "      \"content\": \""
    cat "working/current-folder.txt" | escape_for_json
    echo "\""
    echo "    }"
    echo "  ]"
    echo "}"
} > working/data.json

# Call OpenAI API
curl https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d @working/data.json > working/response.json

# Extract the response content
content=$(cat working/response.json | jq '.choices[0].message.content' | awk '{gsub(/"/, ""); print}')

# Check if README.md exists, if not, create it
if [[ ! -f "$target_directory/README.md" ]]; then
    touch "$target_directory/README.md"
fi

# Append the response to README.md in markdown format
echo "$content" > "$target_directory/README.md"

echo "Analysis complete and appended to $target_directory/README.md"
