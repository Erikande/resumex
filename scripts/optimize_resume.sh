#!/bin/bash

# Usage:
# ./scripts/optimize_resume.sh <ROLE_SLUG> <COMPANY_SLUG>
# Example:
# ./scripts/optimize_resume.sh senior_qa_engineer coursedog

ROLE_SLUG=$1
COMPANY_SLUG=$2

if [ -z "$ROLE_SLUG" ] || [ -z "$COMPANY_SLUG" ]; then
  echo "❌ Usage: $0 <ROLE_SLUG> <COMPANY_SLUG>"
  exit 1
fi

BASE="base/resume_erik-anderson_ic-base.json"
DEST="input/erik_anderson_resume_${ROLE_SLUG}.json"
RESUME="erik_anderson_resume_${ROLE_SLUG}"

if [ ! -f "$BASE" ]; then
  echo "❌ Base resume not found at $BASE"
  exit 1
fi

mkdir -p "$(dirname "$DEST")"

echo "📄 Copying base resume → $DEST"
cp "$BASE" "$DEST"

echo ""
echo "✅ Ready for ATS optimization via GPT:"
echo "→ Input file: $DEST"
echo "→ JD: (paste into GPT)"
echo "📂 Prompt file: Resume Prompts 2025/ATS Resume Optimizer (Schema-Safe).md"
echo "💡 Tip: Use 'diff -u $BASE $DEST' to see what changed."

echo ""
read -p "⏳ Press Enter once you've optimized the file in GPT and saved to $DEST..."

echo "🔎 Validating optimized resume..."
make validate INPUT="$DEST" || exit 1

echo "🖨️ Rendering PDF..."
make resume RESUME="$RESUME" INPUT="$DEST"

echo ""
echo "📁 PDF generated: output/${RESUME}.pdf"
echo "✅ Review complete. If satisfied, run:"
echo "→ make export-app-package RESUME=$RESUME COMPANY=$COMPANY_SLUG ROLE=$ROLE_SLUG"
