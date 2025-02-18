#!/bin/bash

# Check if correct arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <csv_directory> <androzoo_api_key>"
    exit 1
fi

CSV_DIR="$1"  # CSV directory
API_KEY="$2"  # AndroZoo API key 

# Output directory for downloaded APKs
OUTPUT_DIR="./downloaded_apks"
mkdir -p "$OUTPUT_DIR"

# Column name containing SHA-256 hashes change if needed must change the API call url also
COLUMN_NAME="sha256"


process_csv() {
    local csv_file="$1"
    local csv_filename=$(basename "$csv_file" .csv)
    local failed_log="./failed_downloads_${csv_filename}.txt"
    
    echo "Processing: $csv_file"
    > "$failed_log"  

    # Extract SHA-256 hashes (ignoring the header)
    awk -F ',' -v col="$COLUMN_NAME" '
        NR==1 {
            for (i=1; i<=NF; i++) {
                if ($i == col) colnum = i
            }
        }
        NR>1 && colnum { print $colnum }
    ' "$csv_file" | while read -r sha256; do
        echo "Downloading: $sha256"
        curl -G --silent --show-error --fail --remote-header-name \
            -d apikey="$API_KEY" \
            -d sha256="$sha256" \
            "https://androzoo.uni.lu/api/download" \
            -o "$OUTPUT_DIR/$sha256.apk"

        if [ $? -ne 0 ]; then
            echo "$sha256" >> "$failed_log"
            echo "Failed to download: $sha256 (logged in $failed_log)"
        fi
    done
}

# Iterate over all CSV files in the directory
for csv in "$CSV_DIR"/*.csv; do
    [ -f "$csv" ] && process_csv "$csv"
done

echo "Download complete. APKs saved in $OUTPUT_DIR"
