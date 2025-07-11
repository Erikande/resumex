.PHONY: resume resume-md pandoc-pdf resume-cli-pdf html html-theme validate lint clean open help export-app-package backup-input optimize apply ship

RESUME ?= erik_anderson_resume_$(ROLE)
INPUT ?= input/$(RESUME).json
OUTPUT_MD ?= output/$(RESUME).md
OUTPUT_PDF ?= output/$(RESUME).pdf
SCHEMA ?= schema_custom.json
TEMPLATE ?= templates/xoi_style.j2
APP_ROOT ?= $(HOME)/Documents/Heather Job Stack/3. 📬 Applications/Sent

resume: resume-md pandoc-pdf  ## Render full pipeline: Markdown + PDF

resume-md:  ## Render Markdown from JSON resume
	@echo "Rendering Markdown for: $(RESUME)"
	python3 scripts/render_jsonresume_to_md.py "$(INPUT)" --template $(TEMPLATE)

pandoc-pdf:  ## Convert Markdown to PDF via Pandoc
	@echo "Generating PDF from Markdown..."
	pandoc "$(OUTPUT_MD)" -o "$(OUTPUT_PDF)" \
		--pdf-engine=xelatex \
		-V geometry=margin=0.7in \
		-V fontsize=10pt \
		-V lineheight=1.05 \
		-V mainfont="Helvetica Neue"
	@echo "✅ PDF written to: $(OUTPUT_PDF)"

validate:  ## Validate resume JSON against schema and top-level key checks
	@echo "Validating resume JSON against $(SCHEMA)..."
	@python3 scripts/validate_jsonschema.py $(SCHEMA) "$(INPUT)"

optimize:
	@bash scripts/optimize_resume.sh "$(ROLE)" "$(COMPANY)"

lint:  ## Lint generated Markdown with markdownlint
	markdownlint output/*.md

clean:  ## Remove all output artifacts
	rm -rf output/*.md output/*.pdf output/*.html

open:  ## Open rendered PDF
	open $(OUTPUT_PDF)

export-app-package:  ## Export resume PDF to application folder (add OPEN=1 to reveal in Finder)
	@mkdir -p "$(APP_ROOT)/$(COMPANY)"
	cp output/$(RESUME).pdf "$(APP_ROOT)/$(COMPANY)/Erik_Anderson_$(ROLE)_Resume.pdf"
	@echo "✅ Saved to: $(APP_ROOT)/$(COMPANY)"
	@if [ "$(OPEN)" = "1" ]; then open "$(APP_ROOT)/$(COMPANY)"; fi

backup-input:  ## Backup resume JSON before editing
	@mkdir -p backups
	cp $(INPUT) backups/$(notdir $(INPUT)).bak.$(shell date +%Y%m%d_%H%M%S).json
	@echo "🛡️  Backup saved to backups/"

apply: optimize resume  ## Optimize + render resume

ship: optimize resume export-app-package  ## Optimize, render, and export to application folder

help:  ## Show all available Make targets
	@awk 'BEGIN { FS = ":.*?## " } /^[a-zA-Z0-9_-]+:.*?## / { printf "  %-20s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
