# === Configuration ===
RESUME ?= planhub_ic
INPUT = input/resume_$(RESUME).json
MD_OUTPUT = output/resume_$(RESUME).md
PDF_OUTPUT = output/resume_$(RESUME).pdf
TEMPLATE ?= xoi_style.j2
SCHEMA := schema_custom.json

# === Targets ===

resume:  ## Render Markdown and PDF using custom Jinja2 template
	@echo "Rendering Markdown + PDF for: $(RESUME)"
	python3 scripts/render_jsonresume_to_md.py $(INPUT) --template templates/$(TEMPLATE)
	pandoc $(MD_OUTPUT) -o $(PDF_OUTPUT) \
		--pdf-engine=xelatex \
		-V geometry=margin=0.7in \
		-V fontsize=10pt \
		-V lineheight=1.05 \
		-V mainfont="Helvetica Neue"
	@echo "✅ PDF generated at: $(PDF_OUTPUT)"

resume-md:  ## Render Markdown from JSON using selected template
	python3 scripts/render_jsonresume_to_md.py $(INPUT) --template templates/$(TEMPLATE)

pandoc-pdf: resume-md  ## Render PDF from Markdown using Pandoc
	pandoc $(MD_OUTPUT) -o $(PDF_OUTPUT) \
		--pdf-engine=xelatex \
		-V geometry=margin=0.7in \
		-V fontsize=10pt \
		-V lineheight=1.05 \
		-V mainfont="Helvetica Neue"
	@echo "✅ PDF generated at: $(PDF_OUTPUT)"

pandoc-pdf: resume-md  ## Render PDF from Markdown using Pandoc
	pandoc output/resume_$(RESUME).md -o output/resume_$(RESUME).pdf \
		--pdf-engine=xelatex \
		-V geometry=margin=0.7in \
		-V fontsize=10pt \
		-V lineheight=1.05 \
		-V mainfont="Helvetica Neue"
	@echo "✅ PDF rendered from Markdown using default template"

resume-xoi:  ## Build resume PDF using the XOi-style Markdown + Pandoc pipeline
	python3 scripts/render_jsonresume_to_md.py $(INPUT) --template templates/xoi_style.j2
	pandoc output/resume_$(RESUME).md -o output/resume_$(RESUME).pdf \
		--pdf-engine=xelatex \
		-V geometry=margin=0.7in \
		-V fontsize=10pt \
		-V lineheight=1.05 \
		-V mainfont="Helvetica Neue"
	@echo "✅ XOi-style PDF created at: output/resume_$(RESUME).pdf"

resume-html: resume-md  ## Render clean HTML from Markdown
	pandoc output/resume_$(RESUME).md -o output/resume_$(RESUME).html \
		--standalone \
		--metadata title="Erik Anderson Resume" \
		--css templates/xoi_style.css
	@echo "✅ HTML resume created at: output/resume_$(RESUME).html"

resume-cli-pdf:  ## Render PDF using resume-cli with 'compact' theme
	@echo "Rendering PDF via resume-cli with 'compact' theme"
	resume export $(PDF_OUTPUT) --resume $(INPUT) --theme compact || true

html:  ## Render HTML using resume-cli with 'elegant' theme
	@echo "Rendering HTML via resume-cli with 'elegant' theme"
	resume export output/resume_$(RESUME).html --resume $(INPUT) --theme elegant || true

html-theme:  ## Render HTML using selected resume-cli theme (override with THEME=your-theme)
	@echo "Rendering HTML with theme '$(THEME)'"
	resume export output/resume_$(RESUME)_$(THEME).html --resume $(INPUT) --theme $(THEME) || true

validate:  ## Validate resume JSON against schema_custom.json
	@echo "Validating resume JSON against $(SCHEMA)..."
	@python3 scripts/validate_jsonschema.py $(SCHEMA) $(INPUT)

lint:  ## Lint generated Markdown with markdownlint
	markdownlint output/*.md

clean:  ## Remove all generated output files
	rm -f output/*.md output/*.pdf output/*.html

open:  ## Open the latest HTML resume in default browser
	open output/resume_$(RESUME).html

help:  ## Show this help message
	@echo
	@echo "Available Make targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo

.PHONY: resume resume-md pandoc-pdf resume-cli-pdf html html-theme validate lint clean open help
