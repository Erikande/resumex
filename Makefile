# === Configuration ===
RESUME ?= planhub_ic
INPUT = input/resume_$(RESUME).json
MD_OUTPUT = output/resume_$(RESUME).md
PDF_OUTPUT = output/resume_$(RESUME).pdf
TEMPLATE ?= xoi_style.j2

# === Targets ===

# Render Markdown and PDF via Pandoc
resume:
	@echo "Rendering Markdown + PDF for: $(RESUME)"
	python3 scripts/render_jsonresume_to_md.py $(INPUT) --template $(TEMPLATE)
	pandoc $(MD_OUTPUT) -o $(PDF_OUTPUT) \
		--pdf-engine=xelatex \
		-V geometry=margin=0.7in \
		-V fontsize=10pt \
		-V lineheight=1.05 \
		-V mainfont="Helvetica Neue"

# HTML output via resume-cli
html:
	@echo "Rendering HTML via resume-cli with 'elegant' theme"
	resume export output/resume_$(RESUME).html --resume $(INPUT) --theme elegant || true

# PDF output via resume-cli
resumake-pdf:
	@echo "Rendering PDF via resume-cli with 'compact' theme"
	resume export output/resume_$(RESUME).pdf --resume $(INPUT) --theme compact || true

# Lint Markdown
lint:
	markdownlint output/*.md

# Clean output files
clean:
	rm -f output/*.md output/*.pdf output/*.html

# Convenience
open:
	open output/resume_$(RESUME).pdf

SCHEMA := schema_custom.json

validate:
	@echo "Validating resume JSON against $(SCHEMA)..."
	@python3 scripts/validate_jsonschema.py $(SCHEMA) input/resume_$(RESUME).json
