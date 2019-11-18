# Introduction à la console Python dans QGIS

## La documentation et les liens utiles:

* QGIS est composé de plusieurs centaines de classes écrites en C++. La plupart de ces classes (et donc des fonctions) sont accessibles à travers un API en Python. Comme il n'est pas possible de mémoriser entièrement l'API de QGIS, il est nécessaire de connaître la documentation et comment rechercher des informations.
* QGIS repose sur la librairie Qt version 5 pour l'interface graphique et sur Python version 3.
* Toutes les classes QGIS commencent par `Qgs` et toutes les classes Qt commencent par `Q`.

Voici une liste de liens pour la documentation:

* [https://docs.qgis.org](https://docs.qgis.org) qui regroupe:
	* [Le Python Cookbook https://docs.qgis.org/3.4/en/docs/pyqgis_developer_cookbook](https://docs.qgis.org/3.4/en/docs/pyqgis_developer_cookbook/) (recette de cuisine)
	* [L'API C++ https://qgis.org/api/3.4/](https://qgis.org/api/3.4/)
	* [L'API Python https://qgis.org/pyqgis/3.4/](https://qgis.org/pyqgis/3.4/)

Voici une liste non exhaustives de blog-post utiles pour manipuler PyQGIS:

* [Optimisation des couches vecteurs](https://nyalldawson.net/2016/10/speeding-up-your-pyqgis-scripts/)
* [Parcourir la légende en 3 parties](https://www.lutraconsulting.co.uk/blog/2014/07/06/qgis-layer-tree-api-part-1/)
* [Plugin Processing](http://www.qgistutorials.com/en/docs/3/processing_python_plugin.html)

Autre lien pour l'apprentissage de Python:
* [https://openclassrooms.com/fr/courses/235344-apprenez-a-programmer-en-python](https://openclassrooms.com/fr/courses/235344-apprenez-a-programmer-en-python)

## Configurer le projet

* Commencer un nouveau projet et enregistrer le.
* À côté du projet, ajouter le dossier provenant de OSM2Igeo, par exemple `201909_11_ILE_DE_FRANCE_SHP_L93_2154`.

## Manipulation dans la console

* `Plugins` -> `Console Python`
* QGIS nous donne accès au projet actuel via la classe `QgsProject`
	* [https://qgis.org/api/classQgsProject.html](https://qgis.org/api/classQgsProject.html)
	* [https://qgis.org/pyqgis/3.4/core/QgsProject.html](https://qgis.org/pyqgis/3.4/core/QgsProject.html)
	
* Dans la documentation (en C++ surtout), on remarque plusieurs sections:
	* Public types
	* Public slots
	* Signals
	* Public Member Functions
	* Static Public Member Functions
* Nous verrons progressivement ces différentes sections.
* Recherchons `filename`.
```python
QgsProject.instance().fileName()
```
* Ajoutons un titre à notre projet: `setTitle`.
* Objectif, ajouter une couche vecteur contenu dans un dossier fils:
	* Recherchons le dossier racine du projet.
	* Nous allons utiliser le module `os.path` pour manipuler les dossier.
	* [https://docs.python.org/3/library/os.path.html](https://docs.python.org/3/library/os.path.html)
	* `join`, `isfile`, `isdir`

```python
racine = QgsProject.instance().homePath()
from os.path import join, isfile, isdir
join(racine,'nexistepas')
'/home/etienne/Documents/3liz/formation/nexistepas'
isfile(join(racine,'nexistepas'))
False
isdir(join(racine,'nexistepas'))
False
chemin = join(racine, '201909_11_ILE_DE_FRANCE_SHP_L93_2154', 'H_OSM_ADMINISTRATIF')
fichier_shape = join(chemin, 'COMMUNE.shp')
isfile(fichier_shape)
True
```
* Charger la couche vecteur à l'aide de `iface` [QgisInterface](https://qgis.org/api/classQgisInterface.html) (et non pas QgsInterface!)
```python
communes = iface.addVectorLayer(fichier_shape, 'communes', 'ogr')
print(communes)
```
* Charger la couche autrement (conseillé)
```python
communes = QgsVectorLayer(fichier_shape, 'communes', 'ogr')
communes.isValid()
QgsProject.instance().addMapLayer(communes)
```
* Explorer l'objet `communes` qui est un `QgsVectorLayer` à l'aide de la documentation pour chercher sa géométrie, le nombre d'entité.
* Pour la géométrie, toujours utiliser l'énumération et non pas le chiffre.
* Essayer d'ouvrir et de clore une session édition
* Essayer désormais de chercher son nom, la projection ou encore les seuils de visibilité de la couche. Pour cela, il faut faire référence à la notion d'héritage en Programmation Orientée Objet.
* Objectif, ne pas afficher la couche commune pour une échelle plus petite que le 1:2 000 000

## Code

Petit récapitulatif à tester pour voir si cela fonctionne correctement!
*Appuyer sur entrée jusqu'à l'apparition de `>>>` et non pas `...`*

```python
from os.path import join, isfile, isdir
dossier = '201909_11_ILE_DE_FRANCE_SHP_L93_2154'
thematique = 'H_OSM_ADMINISTRATIF'
couche = 'COMMUNE'

racine = QgsProject.instance().homePath()
fichier_shape = join(racine, dossier, thematique, '{}.shp'.format(couche))
layer = QgsVectorLayer(fichier_shape, couche, 'ogr')
result = QgsProject.instance().addMapLayer(layer)

print(layer.featureCount())
print(layer.crs().authid())
print('Est en mètre : {}'.format(layer.crs().mapUnits() ==  QgsUnitTypes.DistanceMeters))
print(layer.name())
layer.setScaleBasedVisibility(True)
layer.setMaximumScale(1)
layer.setMinimumScale(2000000)
layer.triggerRepaint()
```