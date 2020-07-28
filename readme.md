---
Title: PyQGIS
Favicon: logo.png
...

[TOC]

# Formation PyQGIS

Format HTML : https://3liz.github.io/formation-pyqgis/
Format Markdown : https://github.com/3liz/formation-pyqgis/blob/master/readme.md

## Pré-requis

Cette formation concerne des utilisateurs de QGIS, géomaticiens, qui souhaitent apprendre l'API Python de QGIS :

* Ajout de fonctionnalités à QGIS
* Automatisation de certains traitements
* Création de script
* Création d'algorithme Processing

Pour suivre la formation, il faut:

* Avoir QGIS 3.4 minimum
* Avoir des bases en programmation
* Avoir un jeu de données, par exemple:
    * Données OSM à l'aide du plugin QuickOSM
    * Données [OSM2Igeo](https://github.com/igeofr/osm2igeo) (utilisation de ce jeu de données ci-après dans la formation)

## Sommaire

* [Où utiliser du Python dans QGIS ?](./le_python_dans_qgis.md)
* [Mémo Python](./00_memo_python.md)
* [Découverte de la console Python dans QGIS](./01_console_python.md)
    * La documentation et l'API
    * Initiation à la Programmation Orientée Objet (POO)
    * Accèder aux propriétés du projet
    * Ajouter une couche
    * Accèder aux propriétés de la couche
    * Itération sur une couche vecteur
* [Initiation au script Python](./02_fonctions_script.md)
    * Organiser son code en fonction
    * Manipulation des structures de données
    * Exporter des informations sur les couches au format CSV
    * Communication avec l'utilisateur
* [Sélection et parcours des entités](./03_selection_parcours_entites.md)
    * Sélection
    * Filtrage
    * Optimisation
    * Parcours sur une table attributaire
    * Matérialisation
    * Ajout d'un champ et calcul d'un indicateur pour chaque entité
    * Manipulation de la géométrie
* [Actions](./04_actions.md)
    * Les actions par défaut
    * Créer sa propre action pour inverser une ligne
* [Script Processing](./05_script_processing.md)
    * Le modèle de script déjà existant
    * Création d'une structure de couche vecteur à partir d'un CSV
