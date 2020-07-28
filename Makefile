github-pages:
	@rm -rf docs/
	@mkdir docs/
	@cp -R media/ docs/media/
	@cp logo.png docs/
	@docker run --rm -w /plugin -v $(shell pwd):/plugin etrimaille/pymarkdown readme.md docs/index.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin etrimaille/pymarkdown 00_memo_python.md docs/00_memo_python.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin etrimaille/pymarkdown 01_console_python.md docs/01_console_python.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin etrimaille/pymarkdown 02_fonctions_script.md docs/02_fonctions_script.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin etrimaille/pymarkdown 03_selection_parcours_entites.md docs/03_selection_parcours_entites.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin etrimaille/pymarkdown 04_actions.md docs/04_actions.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin etrimaille/pymarkdown 05_script_processing.md docs/05_script_processing.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin etrimaille/pymarkdown le_python_dans_qgis.md docs/le_python_dans_qgis.html
