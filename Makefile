github-pages:
	@rm -rf docs/
	@mkdir docs/
	@cp -R media/ docs/media/
	@cp logo.png docs/
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown readme.md docs/index.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 00_memo_python.md docs/00_memo_python.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 01_console_python.md docs/01_console_python.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 02_fonctions_script.md docs/02_fonctions_script.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 03_selection_parcours_entites.md docs/03_selection_parcours_entites.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 04_actions.md docs/04_actions.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 05_script_processing.md docs/05_script_processing.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown le_python_dans_qgis.md docs/le_python_dans_qgis.html
