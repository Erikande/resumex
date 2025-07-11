import json
import sys
import jsonschema

REQUIRED_TOP_LEVEL_KEYS = ["basics", "work", "education", "skills", "summary"]

def sanity_check(data, json_path):
    missing_keys = [key for key in REQUIRED_TOP_LEVEL_KEYS if key not in data]
    if missing_keys:
        print(f"[✗] Sanity check failed for {json_path}: Missing keys → {', '.join(missing_keys)}")
        sys.exit(1)

    # Check for basics.profiles[0].url
    try:
        profiles = data["basics"].get("profiles", [])
        if profiles and not isinstance(profiles[0].get("url", None), str):
            print(f"[✗] Sanity check: basics.profiles[0].url should be a string")
            sys.exit(1)
    except Exception as e:
        print(f"[✗] Sanity check failed while accessing basics.profiles[0].url: {e}")
        sys.exit(1)

def validate_json(schema_path, json_path):
    with open(schema_path, 'r') as schema_file:
        schema = json.load(schema_file)

    with open(json_path, 'r') as json_file:
        data = json.load(json_file)

    # Run sanity checks before schema validation
    sanity_check(data, json_path)

    try:
        jsonschema.validate(instance=data, schema=schema)
        print(f"[✓] {json_path} is valid against {schema_path}")
    except jsonschema.exceptions.ValidationError as e:
        print(f"[✗] Schema validation failed:\n    → {e.message}\n    → At: {list(e.path)}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python validate_jsonschema.py <schema_file> <json_file>")
        sys.exit(1)

    validate_json(sys.argv[1], sys.argv[2])
