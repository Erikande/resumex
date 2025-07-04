import json
import sys
from jsonschema import Draft4Validator

def main(schema_path, resume_path):
    with open(schema_path, "r", encoding="utf-8") as f:
        schema = json.load(f)
    with open(resume_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    validator = Draft4Validator(schema)
    errors = sorted(validator.iter_errors(data), key=lambda e: e.path)

    if not errors:
        print(f"[✓] {resume_path} is valid")
    else:
        print(f"[!] {resume_path} has schema errors:\n")
        for error in errors:
            path = ".".join(str(p) for p in error.path)
            print(f"  - {path}: {error.message}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python validate_jsonschema.py <schema.json> <resume.json>")
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])
