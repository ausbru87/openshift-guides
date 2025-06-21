#!/usr/bin/env bash
# Combine markdown files in openshift-airgap-deployment/deployment and generate a PDF
set -euo pipefail

# Base directory containing deployment phases
BASE_DIR="openshift-airgap-deployment/deployment"
OUTPUT_PDF="openshift-airgap-deployment/deployment.pdf"

# Create a temporary file to hold combined markdown
TMP_MD=$(mktemp)

# Find all markdown files under BASE_DIR, sort them, and concatenate
find "$BASE_DIR" -type f -name '*.md' | sort | while read -r file; do
  cat "$file" >> "$TMP_MD"
  echo -e "\n\n" >> "$TMP_MD"
done

# Generate PDF using pandoc. Disable YAML metadata blocks to avoid parsing
# horizontal rules starting with `---` as metadata headers.
pandoc -f markdown-yaml_metadata_block --pdf-engine=xelatex "$TMP_MD" -o "$OUTPUT_PDF"

# Remove temporary file
rm "$TMP_MD"

echo "PDF generated at $OUTPUT_PDF"
