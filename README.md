# Repository Analysis

This repository includes scripts that are designed to perform a specific task related to documentation analysis using the OpenAI API. Here's an overview of the main components and functionalities provided:

- `analyze.sh`: 
  - Analyzes the target directory specified as an argument.
  - Sources environment variables from `env.sh`, defines the target directory, calls `dump-folder.sh` to dump the contents of the target directory into a file.
  - Prepares data for an OpenAI API call by formatting JSON and escaping special characters.
  - Calls the OpenAI API with the prepared data and extracts the response.
  - If `README.md` does not exist in the target directory, it creates one and appends the OpenAI API response in markdown format.

- `dump-folder.sh`:
  - Dumps the contents of the provided target directory.
  - Creates a `working` directory within the target directory.
  - Processes each file in the target directory.
  - Checks for the presence of a `.gitignore` file and saves the contents of each file in `current-folder.txt`.

- `env.sh`: 
  - Contains the environment variable `OPENAI_API_KEY` required for authorization in the OpenAI API call.