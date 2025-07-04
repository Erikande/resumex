# Resume CLI V2

This project provides a clean, Markdown-first pipeline for managing and rendering resumes using the [JSON Resume Schema](https://jsonresume.org/schema/). It uses Jinja2 templates for layout and Pandoc for PDF generation.

---

## 📁 Project Structure

```
resume-cli-v2/
├── input/                  # JSON Resume files (AST-optimized)
│   └── resume_planhub_ic.json
├── output/                 # Generated output
│   ├── resume_planhub_ic.md
│   └── resume_planhub_ic.pdf
├── scripts/
│   └── render_jsonresume_to_md.py
├── templates/
│   └── xoi_style.j2
├── Makefile
└── README.md
```

---

## ✅ Usage

### 🛠 Render Markdown + PDF

```bash
make resume RESUME=planhub_ic
```

- Reads `input/resume_planhub_ic.json`
- Renders to:
  - `output/resume_planhub_ic.md`
  - `output/resume_planhub_ic.pdf`

Optional flags:

```bash
make resume RESUME=planhub_ic TEMPLATE=xoi_style.j2
```

| Flag        | Description                          |
|-------------|--------------------------------------|
| `RESUME`    | Resume filename stem (no extension)  |
| `TEMPLATE`  | Jinja2 template filename             |

---

## 📦 Requirements

- Python 3.8+
- [Pandoc](https://pandoc.org/)
- [MacTeX](https://tug.org/mactex/) or any `xelatex`-capable engine

Install Python deps:

```bash
pip install -r requirements.txt
```

Install LaTeX (macOS):

```bash
brew install --cask mactex
```

---

## 📄 JSON Resume Format

Each resume must follow the [JSON Resume Schema](https://jsonresume.org/schema/). Example keys:

```json
{
  "basics": {
    "name": "Erik Anderson",
    "email": "erika.qa@pm.me",
    "phone": "+1-202-709-3272"
  },
  "summary": "...",
  "skills": [...],
  "experience": [...],
  "education": [...],
  "certificates": [...]
}
```

---

## 🧠 Template Features

### ✨ `xoi_style.j2` Template

- Headline layout with bold role
- Formatted dates: `MM-YYYY`
- ASCII-only: no unicode dashes or symbols
- Clean for Markdown/PDF export

Supported template flags (opt-in via JSON or code):

```jinja2
{% if show_contact %} ... {% endif %}
{% if summary_short %} ... {% endif %}
{% if show_certs %} ... {% endif %}
```

These can be added in the render script:

```python
data["show_contact"] = True
```

---

## 🔧 Makefile Targets

```bash
make resume RESUME=name         # render Markdown + PDF
make clean                      # remove all output files
```

---

## 📄 Output Files

| Format   | Output Path                  |
|----------|------------------------------|
| Markdown | `output/resume_<name>.md`    |
| PDF      | `output/resume_<name>.pdf`   |

---

## 🛠 To-Do

- [ ] Add `summary_short` fallback logic
- [ ] Support contact/certs toggles
- [ ] Automate GPT resume AST optimization
- [ ] Add diff/compare tooling

---

Made with ☕️ and clean CLI vibes.
