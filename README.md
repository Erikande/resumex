# Resume CLI Workflow

This project is a full-featured resume build and deployment pipeline using `make`, Pandoc, Jinja2 templates, Markdown linting, and JSON Resume schema validation. It supports ATS optimization workflows and job application packaging.

---

## 🚀 Features

- ✅ Generate Markdown + PDF from JSON Resume
- ✅ Validate JSON with schema + sanity checks
- ✅ Warp.dev workflows (resume_parse, validate, lint, render, export)
- ✅ Export resume PDF to job application folder
- ✅ Optimizer script to assist with ATS tuning
- ✅ Supports virtualenv activation

---

## 📁 Directory Layout

```
resume-cli-v2/
├── input/               # Optimized resume JSONs per job
├── base/                # Stable master resume JSON
├── output/              # Generated Markdown + PDF files
├── templates/           # Jinja2 + PDF templates
├── scripts/             # Helper scripts (validate, render, optimize)
├── docs/                # GH Pages deployment files
├── .warp/workflows/     # Warp workflow YAMLs
├── schema_custom.json   # JSON Resume validation schema
├── Makefile             # Task runner
└── README.md
```

---

## ⚙️ Setup

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
brew install pandoc
```

---

## 📦 Make Targets

| Target | Description |
| --- | --- |
| `make resume` | Render Markdown + PDF for RESUME + INPUT |
| `make validate` | Validate JSON schema + required key checks |
| `make lint` | Run markdownlint on output files |
| `make export-app-package` | Copy final PDF to application folder (COMPANY + ROLE vars) |
| `make clean` | Delete output/*.md, output/*.pdf |
| `make open` | Open final PDF |
| `make optimize` | Interactive optimization flow for ATS tuning |
| `make help` | List all available targets |

---

## 🧠 Warp Workflows

Stored in `.warp/workflows/`:

- `resume_parse.yml`
- `resume_validate_json.yml`
- `resume_lint_md.yml`
- `resume_render_resume_pdf.yml`
- `resume_export_app_package.yml`
- `resume_venv_activate.yml`

You can import them directly in Warp.

---

## ✨ ATS Optimization Prompt

See `Resume Prompts 2025/ATS Resume Optimizer.md`

Use with GPT like: **CV + Resume: Job Interview Prep (Career PRO)**

---

## 📝 Notes

- Always test with:  
  `make resume RESUME=name INPUT=input/name.json`
- Keep your base file untouched in `base/`
- Validate before running export: `make validate`