import json
import sys
from jsonschema import validate, ValidationError

def main(schema_path, resume_path):
    try:
        with open(schema_path, "r", encoding="utf-8") as s:
            schema = json.load(s)
        with open(resume_path, "r", encoding="utf-8") as r:
            resume = json.load(r)
    except Exception as e:
        print(f"[✗] Error loading files: {e}")
        sys.exit(1)

    try:
        validate(instance=resume, schema=schema)
        print(f"[✓] {resume_path} is valid against {schema_path}")
    except ValidationError as e:
        print(f"[✗] Validation failed:")
        print(f"    → {e.message}")
        print(f"    → At: {list(e.absolute_path)}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python validate_jsonschema.py <schema.json> <resume.json>")
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])
