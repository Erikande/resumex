import json
import argparse
from pathlib import Path
from datetime import datetime
from jinja2 import Environment, FileSystemLoader, select_autoescape

def fmt_date(value):
    """Format date from YYYY-MM to MM-YYYY"""
    if not value:
        return ""
    try:
        return datetime.strptime(value, "%Y-%m").strftime("%m-%Y")
    except ValueError:
        return value  # return as-is if parsing fails

def render_resume(data, output_path, template_name):
    template_dir = Path(__file__).parent.parent / "templates"
    env = Environment(
        loader=FileSystemLoader(template_dir),
        autoescape=select_autoescape()
    )
    env.filters["fmt_date"] = fmt_date

    template = env.get_template(template_name)
    rendered = template.render(**data)

    Path(output_path).parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(rendered)
    print(f"[✓] Rendered Markdown written to {output_path}")

def main():
    parser = argparse.ArgumentParser(description="Render a JSON Resume to Markdown")
    parser.add_argument("input", help="Path to JSON Resume")
    parser.add_argument("--template", required=True, help="Jinja2 template filename (e.g. xoi_style.j2)")
    args = parser.parse_args()

    input_path = Path(args.input)
    output_md = Path("output") / input_path.with_suffix(".md").name

    with open(input_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    render_resume(data, output_md, args.template)

if __name__ == "__main__":
    main()
