#!/bin/zsh

# =========================================================
# CONFIGURATION
# =========================================================
# REPLACE THIS with the actual path to your FitCSVTool.jar
SDK_PATH="/Users/alexrosa/Downloads/FitSDKRelease_21.171.00/java/FitCSVTool.jar"

# =========================================================
# THE LOOP
# =========================================================
echo "Starting conversion using Garmin FIT SDK..."

for file in *.fit; do
    # 1. Safety check: ensure file exists
    [[ -e "$file" ]] || continue

    # 2. Define Output Name (removing .fit and adding .csv)
    # The SDK tool creates the CSV automatically, but we define it 
    # explicitly here to control the naming convention if needed.
    outfile="${file%.fit}.csv"

    echo "Processing: $file"

    # 3. Run the Java Tool
    # Usage: java -jar FitCSVTool.jar <options> <infile> <outfile>
    # -b : Disables syntax verification (faster for batch processing)
    # --data : (Optional) Just output data messages, skip definitions
    java -jar "$SDK_PATH" -b "$file" "$outfile" -se 
    
done

echo "Done! All .fit files converted to CSV."
