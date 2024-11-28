---
hide:
  - navigation
---

# Formation PyQGIS

## Pré-requis

Cette formation concerne des utilisateurs de QGIS, géomaticiens, qui souhaitent apprendre l'API Python de QGIS :

* Ajout de fonctionnalités à QGIS
* Automatisation de certains traitements
* Création de script
* Création d'algorithme Processing

Pour suivre la formation, il faut :

* Avoir [QGIS LTR minimum](https://www.qgis.org/en/site/getinvolved/development/roadmap.html#release-schedule)
* Avoir des connaissances en QGIS bureautique
* Avoir quelques bases en programmation
* Avoir un jeu de données, par exemple :
    * BD Topo du département 

Si nécessaire, il peut être utile d'avoir en plus :

* [qgis_process](./standalone.md#qgis-process)
* QtDesigner pour la partie sur les formulaires ou une extension graphique

## Plan

* Présentation
    * [Python dans QGIS](python-qgis.md)
    * [Documentation](./documentation.md)
    * [Mémo Python](memo-python.md), sans PyQGIS
* Premier pas avec l'API PyQGIS
    * [Console](console.md)
    * [Fonctions & Scripts](fonctions-scripts.md)
    * [Sélection & Parcours](selection-parcours-entites.md)
* Utilisation simple
    * [Action](action.md)
    * [Expression](expression.md)
    * [Formulaire](formulaire.md)
    <!-- * [Manipuler la légende et une jointure](legende.md) -->
* Utilisation avancée
    * [Écriture de notre classe en POO](./ecriture-classe-poo.md)
    * [Script Processing](script-processing.md)
    * [Extension générique](extension-generique.md)
    * [Extension graphique](extension-graphique.md)
    * [Extension Processing](extension-processing.md)
    * [Application standalone](standalone.md)
* Sujets PyQGIS thématiques
    * [Migration majeure au sein d'un code Python](migration-majeure.md)
    * [Interroger une base PostGIS](postgis.md)
* Outils annexes
    * [Déploiement d'une extension](extension-deploiement.md)
    * [IDE Python & Git](ide-git.md)
