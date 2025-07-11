#!/bin/bash

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

echo "✅ Proceeding with validation and rendering in Makefile..."
