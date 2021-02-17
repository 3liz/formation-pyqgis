---
Title: PyQGIS
Favicon: logo.png
...

[TOC]

# Formation PyQGIS

* Format HTML : https://docs.3liz.org/formation-pyqgis/
* Format Markdown : https://github.com/3liz/formation-pyqgis/blob/master/readme.md

## Pré-requis

Cette formation concerne des utilisateurs de QGIS, géomaticiens, qui souhaitent apprendre l'API Python de QGIS :

* Ajout de fonctionnalités à QGIS
* Automatisation de certains traitements
* Création de script
* Création d'algorithme Processing

Pour suivre la formation, il faut :

* Avoir [QGIS LTR minimum](https://www.qgis.org/en/site/getinvolved/development/roadmap.html#release-schedule)
* Avoir des connaissances en QGIS bureautique
* Avoir des bases en programmation
* Avoir un jeu de données, par exemple :
    * Données OSM à l'aide du plugin QuickOSM
    * Données [OSM2Igeo](https://github.com/igeofr/osm2igeo) (utilisation de ce jeu de données ci-après dans 
      la formation)

## Sommaire

* [Où utiliser du Python dans QGIS ?](./00_le_python_dans_qgis.md)
* [Mémo Python](./05_memo_python.md)
* [Pour une utilisation sur le long terme](./10_travailler_avec_python.md)
    * IDE
    * GIT
* [Découverte de la console Python dans QGIS](./15_console_python.md)
    * La documentation et l'API
    * Initiation à la Programmation Orientée Objet (POO)
    * Accéder aux propriétés du projet
    * Ajouter une couche
    * Accéder aux propriétés de la couche
    * Itération sur une couche vecteur
* [Initiation au script Python](./20_fonctions_script.md)
    * Organiser son code en fonction
    * Manipulation des structures de données
    * Exporter des informations sur les couches au format CSV
    * Communication avec l'utilisateur
* [Sélection et parcours des entités](./25_selection_parcours_entites.md)
    * Sélection
    * Filtrage
    * Optimisation
    * Parcours sur une table attributaire
    * Matérialisation
    * Ajout d'un champ et calcul d'un indicateur pour chaque entité
    * Manipulation de la géométrie
    * Les exceptions (les erreurs) en Python
* Faire une symbologie
    * Utiliser PyQGIS pour créer dynamiquement une symbologie
    * Charger un QML
* [Actions](./50_actions.md)
    * Les actions par défaut
    * Créer sa propre action pour inverser une ligne
* [Script Processing](./60_script_processing.md)
    * Introduction à la POO
    * Transformer un modèle en script Processing
    * Le modèle de script déjà existant
    * Création d'une structure de couche vecteur à partir d'un CSV
* [Créer une extension de base](./70_extension.md)
* [Faire une extension Processing](./75_extension_processing.md)
    * Créer un fournisseur Processing
* [Faire une extension avec une UI](./80_extension_graphique.md)
    * Créer une UI avec QtDesigner
    * Les signaux Qt
* Déploiement d'une extension QGIS
    * Interne versus public
    * plugins.qgis.org
    * QGIS-Plugin-CI
* Lancer QGIS sans ouvrir QGIS, en CLI
    * `qgis_process` pour lancer un script/modèle Processing sans ouvrir QGIS
    * PyQGIS standalone script
