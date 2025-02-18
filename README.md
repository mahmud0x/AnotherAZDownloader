# AnotherAZDownloader
A Bash script to download APKs from AndroZoo using SHA-256 hashes extracted from CSV files. It supports batch processing, logs failed downloads per CSV file, and organizes downloaded APKs efficiently.
Features:

✅ Parses multiple CSV files to extract SHA-256 hashes
✅ Downloads APKs using AndroZoo’s API
✅ Logs failed downloads in failed_downloads_<CSV_FILENAME>.txt
✅ Organizes APKs in a dedicated directory

Usage:
./download_apks_from_csv.sh /path/to/csv_directory your_api_key
