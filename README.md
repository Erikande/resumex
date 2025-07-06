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

### 🛠 Build Full Resume (Markdown + PDF)

```bash
make resume-xoi RESUME=erik-anderson_ic-base INPUT=base/resume_erik-anderson_ic-base.json
```

This renders:

- `output/resume_erik-anderson_ic-base.md`
- `output/resume_erik-anderson_ic-base.pdf`

### 🌐 Build HTML Version

```bash
make resume-html RESUME=erik-anderson_ic-base INPUT=base/resume_erik-anderson_ic-base.json
```

This renders:

- `output/resume_erik-anderson_ic-base.html`

### 🚀 Deploy to GitHub Pages

```bash
make deploy-pages RESUME=erik-anderson_ic-base
```

This copies `.html`, `.pdf`, and `.css` to `docs/` for GitHub Pages.

---

## 📦 Requirements

- Python 3.8+
- [Pandoc](https://pandoc.org/)
- [MacTeX](https://tug.org/mactex/) or any `xelatex`-capable engine

Install Python dependencies:

```bash
pip install -r requirements.txt
```

Install LaTeX on macOS:

```bash
brew install --cask mactex
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
make resume-xoi             # Markdown + PDF via xoi_style.j2
make resume-html            # HTML from Markdown + CSS
make deploy-pages           # Copy output to /docs for GitHub Pages
make clean                  # Remove output files
make validate               # Validate resume JSON against schema_custom.json
```

---

## 🔄 Output Files

| Format   | Path                              |
|----------|-----------------------------------|
| Markdown | `output/resume_<name>.md`         |
| PDF      | `output/resume_<name>.pdf`        |
| HTML     | `output/resume_<name>.html`       |
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
