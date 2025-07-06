import sys
import json
from jinja2 import Environment, FileSystemLoader
from datetime import datetime

def fmt_date(date_str):
    if not date_str:
        return ""
    try:
        return datetime.strptime(date_str, "%Y-%m").strftime("%b %Y")
    except ValueError:
        return date_str

def main():
    if len(sys.argv) < 4:
        print("Usage: python render_jsonresume_to_md.py input.json --template template_file.j2")
        sys.exit(1)

    input_file = sys.argv[1]
    template_flag = sys.argv[2]
    template_file = sys.argv[3]

    if template_flag != "--template":
        print("Error: Second argument must be --template")
        sys.exit(1)

    # Load the JSON data
    with open(input_file, "r", encoding="utf-8") as f:
        resume_data = json.load(f)

    # Setup Jinja2 environment
    env = Environment(loader=FileSystemLoader(searchpath="."), trim_blocks=True, lstrip_blocks=True)
    env.filters["fmt_date"] = fmt_date

    # Load the template
    template = env.get_template(template_file)

    # Render the resume
    output = template.render(resume_data)

    # Write to Markdown file
    output_file = input_file.replace(".json", ".md").split("/")[-1]
    with open(f"output/{output_file}", "w", encoding="utf-8") as f:
        f.write(output)

    print(f"[✓] Rendered Markdown written to output/{output_file}")

if __name__ == "__main__":
    main()
