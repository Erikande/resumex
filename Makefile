# ========= Configurable Vars =========
RESUME      ?= erik_anderson_resume_final
INPUT       ?= input/$(RESUME).json
MD_OUTPUT   = output/$(RESUME).md
PDF_OUTPUT  = output/$(RESUME).pdf
HTML_OUTPUT = output/$(RESUME).html
SCHEMA      ?= schema_custom.json
APP_ROOT    ?= /Users/heather/Documents/Heather\ Job\ Stack/3.\ 📬\ Applications/Sent
COMPANY     ?= ExampleCorp
ROLE        ?= Software_Engineer

# ========= Resume Build Pipeline =========
resume: $(PDF_OUTPUT)

$(MD_OUTPUT): $(INPUT)
	@echo "Rendering Markdown for: $(RESUME)"
	python3 scripts/render_jsonresume_to_md.py $(INPUT) --template templates/xoi_style.j2

$(PDF_OUTPUT): $(MD_OUTPUT)
	@echo "Rendering PDF for: $(RESUME)"
	pandoc $(MD_OUTPUT) -o $(PDF_OUTPUT) \
		--pdf-engine=xelatex \
		-V geometry=margin=0.7in \
		-V fontsize=10pt \
		-V lineheight=1.05 \
		-V mainfont="Helvetica Neue"

resume-html: $(MD_OUTPUT)
	@echo "Rendering HTML for: $(RESUME)"
	pandoc $(MD_OUTPUT) -o $(HTML_OUTPUT) --css=templates/xoi_style.css

# ========= Validation & Linting =========
validate:  ## Validate resume JSON against schema
	@echo "Validating resume JSON against $(SCHEMA)..."
	@python3 scripts/validate_jsonschema.py $(SCHEMA) $(INPUT)

lint:  ## Lint Markdown output
	markdownlint output/*.md

# ========= GitHub Pages Deploy =========
deploy-pages:
	@echo "Deploying resume to GitHub Pages..."
	@mkdir -p docs
	cp $(HTML_OUTPUT) docs/index.html
	cp $(PDF_OUTPUT) docs/resume.pdf
	cp templates/xoi_style.css docs/style.css
	@echo "✅ Copied to docs/"

# ========= App Package Export =========
export-app-package:  ## Export resume to application folder
	@mkdir -p "$(APP_ROOT)/$(COMPANY)"
	cp $(PDF_OUTPUT) "$(APP_ROOT)/$(COMPANY)/Erik_Anderson_$(ROLE)_Resume.pdf"
	@echo "✅ Saved to: $(APP_ROOT)/$(COMPANY)"

# ========= Cleanup =========
clean:
	rm -f output/*.md output/*.pdf output/*.html

.PHONY: resume resume-html validate lint deploy-pages export-app-package clean
