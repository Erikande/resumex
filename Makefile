# Filepaths and config
RESUME ?= erik_anderson_resume_final
INPUT ?= input/$(RESUME).json
PDF_OUTPUT = output/$(RESUME).pdf
MD_OUTPUT = output/$(RESUME).md
HTML_OUTPUT = output/$(RESUME).html
SCHEMA ?= schema_custom.json
APP_ROOT ?= ~/Documents/Heather\ Job\ Stack/3.\ 📬\ Applications/Sent
TEMPLATE ?= templates/xoi_style.j2

# Markdown + PDF pipeline
resume: $(PDF_OUTPUT) ## Build resume PDF from JSON

$(MD_OUTPUT): $(INPUT)
	@echo "Rendering Markdown for: $(RESUME)"
	python3 scripts/render_jsonresume_to_md.py $(INPUT) --template $(TEMPLATE)

$(PDF_OUTPUT): $(MD_OUTPUT)
	@echo "Generating PDF for: $(RESUME)"
	pandoc $< -o $@ \
		--pdf-engine=xelatex \
		-V geometry=margin=0.7in \
		-V fontsize=10pt \
		-V lineheight=1.05 \
		-V mainfont="Helvetica Neue"

# HTML
resume-html: ## Generate standalone HTML resume
	pandoc $(MD_OUTPUT) -o $(HTML_OUTPUT) --standalone --css templates/xoi_style.css

# GitHub Pages deploy
deploy-pages: ## Copy resume to docs/ for GitHub Pages
	@mkdir -p docs
	cp $(HTML_OUTPUT) docs/index.html
	cp $(PDF_OUTPUT) docs/resume.pdf
	cp templates/xoi_style.css docs/style.css
	@echo "✅ Copied to docs/"

# Application output
export-app-package: ## Copy resume PDF to app folder (no CL)
	@mkdir -p "$(APP_ROOT)/$(COMPANY)"
	cp $(PDF_OUTPUT) "$(APP_ROOT)/$(COMPANY)/Erik_Anderson_$(ROLE)_Resume.pdf"
	@echo "✅ Saved to: $(APP_ROOT)/$(COMPANY)"

# Validation
validate: ## Validate resume JSON against schema_custom.json
	@echo "Validating resume JSON against $(SCHEMA)..."
	@python3 scripts/validate_jsonschema.py $(SCHEMA) $(INPUT)

# Markdown lint
lint: ## Lint Markdown in output/
	markdownlint output/*.md

# Cleanup
clean: ## Delete all output files
	rm -f output/*.md output/*.pdf output/*.html

# Help
help: ## Show all available make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-24s\033[0m %s\n", $$1, $$2}'

# Declare all phony targets
.PHONY: resume resume-md pandoc-pdf resume-cli-pdf html html-theme validate lint clean open help resume-html deploy-pages export-app-package
