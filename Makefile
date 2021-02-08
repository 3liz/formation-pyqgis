github-pages:
	@rm -rf docs/
	@mkdir docs/
	@cp -R media/ docs/media/
	@cp logo.png docs/
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown readme.md docs/index.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 00_le_python_dans_qgis.md docs/00_le_python_dans_qgis.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 05_memo_python.md docs/05_memo_python.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 10_travailler_avec_python.md docs/10_travailler_avec_python.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 15_console_python.md docs/15_console_python.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 20_fonctions_script.md docs/20_fonctions_script.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 25_selection_parcours_entites.md docs/25_selection_parcours_entites.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 40_proprietes_vecteurs.md docs/40_proprietes_vecteurs.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 50_actions.md docs/50_actions.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 60_script_processing.md docs/60_script_processing.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 70_extension_processing.md docs/70_extension_processing.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 80_extension_graphique.md docs/70_extension_graphique.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 90_deploiement_extension.md docs/90_deploiement_extension.html
	@docker run --rm -w /plugin -v $(shell pwd):/plugin 3liz/pymarkdown 95_standalone.md docs/95_standalone.html
