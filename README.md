# Resume CLI V2

This project provides a clean, Markdown-first pipeline for managing and rendering resumes using the [JSON Resume Schema](https://jsonresume.org/schema/). It uses Jinja2 templates for layout, Pandoc for PDF and HTML generation, and a Makefile for streamlined builds.

---

## 📁 Project Structure

```tree
resume-cli-v2/
├── base/                    # Canonical source JSON resumes
│   └── resume_erik-anderson_ic-base.json
├── input/                   # Alternate resumes (JD-optimized, archived)
├── output/                  # Generated output files (PDF, MD, HTML)
│   ├── resume_<name>.md
│   ├── resume_<name>.pdf
│   └── resume_<name>.html
├── templates/               # Jinja2 templates and CSS for rendering
│   ├── xoi_style.j2
│   ├── xoi_style.css
│   └── ...
├── scripts/
│   ├── render_jsonresume_to_md.py
│   └── validate_jsonschema.py
├── docs/                    # GitHub Pages deploy folder (optional)
│   ├── index.html
│   ├── resume.pdf
│   └── style.css
├── schema_custom.json       # Custom schema supporting JSON Resume spec
├── Makefile
└── README.md
```

---

## ✅ Usage

### 🧱 Build from JSON

To build from any JSON file in `input/`, just provide its basename:

```bash
make resume RESUME=your_resume_basename
```

This expects a file at:

```
input/your_resume_basename.json
```

It will generate:

- `output/your_resume_basename.md`
- `output/your_resume_basename.pdf`

### 🌐 Build HTML Version

```bash
make resume-html RESUME=your_resume_basename
```

Generates:

- `output/your_resume_basename.html`

### 📤 Deploy to GitHub Pages

```bash
make deploy-pages RESUME=your_resume_basename
```

Copies `.html`, `.pdf`, and `.css` to `docs/` for GH Pages:

```
docs/index.html
docs/resume.pdf
docs/style.css
```

### 📂 Export Application Package

Save rendered resume to your organized app folder:

```bash
make export-app-package RESUME=your_resume_basename COMPANY=FedEx ROLE=Software_Quality_Engineer_Advisor
```

This creates:

```
~/Documents/Heather Job Stack/3. 📬 Applications/Sent/FedEx/
└── Erik_Anderson_Software_Quality_Engineer_Advisor_Resume.pdf
```

🔖 *Cover letter functionality is disabled unless manually included.*

### ✅ Validate JSON Resume

```bash
make validate RESUME=your_resume_basename
```

Checks against `schema_custom.json`

### ✅ Lint Markdown

```bash
make lint
```

Runs `markdownlint` on all Markdown in `output/`

---

## 📦 Requirements

- Python 3.8+
- [Pandoc](https://pandoc.org/)
- [MacTeX](https://tug.org/mactex/) or any `xelatex` engine

Install dependencies:

```bash
pip install -r requirements.txt
brew install --cask mactex  # macOS only
```

---

## 📄 JSON Resume Format

Each resume must follow the [JSON Resume Schema](https://jsonresume.org/schema/). Example:

```json
{
  "basics": {
    "name": "Erik Anderson",
    "email": "erika.qa@pm.me",
    "phone": "+1-202-709-3272",
    "profiles": [
      { "network": "LinkedIn", "url": "https://www.linkedin.com/in/erikande/" }
    ]
  },
  "summary": "...",
  "skills": [...],
  "work": [...],
  "education": [...],
  "certificates": [...]
}
```

---

## 🎨 Templates

### ✨ `xoi_style.j2`

- One-page layout optimized for recruiters
- Helvetica Neue, tight vertical spacing
- Clean formatting for skills, work history, and education
- Used for both PDF and HTML builds

### 🎨 `xoi_style.css`

- Matches XOi-style PDF formatting
- Used when rendering standalone HTML with Pandoc

---

## 🛠 Makefile Targets

```bash
make resume RESUME=name        # Markdown + PDF from JSON in input/
make resume-html RESUME=name   # HTML build from same JSON
make deploy-pages RESUME=name  # Copy assets to /docs
make export-app-package RESUME=name COMPANY=X ROLE=Y  # Output package to folder
make validate RESUME=name      # Validate JSON
make lint                      # Lint Markdown output
make clean                     # Remove generated files
```

---

## 🔄 Output Files

| Format   | Path                                |
|----------|-------------------------------------|
| Markdown | `output/<name>.md`                 |
| PDF      | `output/<name>.pdf`                |
| HTML     | `output/<name>.html`               |
| GH Pages | `docs/index.html`, `docs/resume.pdf` |

---

## 🌐 GitHub Pages (optional)

To publish your resume:

1. Enable Pages in repo → Settings → Pages
2. Choose `main` or `clean-rebuild` branch
3. Set folder: `docs/`
4. Access your live resume at:

```
https://<your-username>.github.io/<your-repo-name>/
```

---

Made with ☕️, Markdown, and CLI power.
