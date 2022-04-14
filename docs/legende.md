# Objectif

À travers ce TP, on va traiter plusieurs points : 

* jointure d'une couche ODS pour récupérer des populations
* appeler un algorithme Processing pour agréger les données
  * retravailler la légende afin d'afficher le nom de la commune et la population dans le libellé

METTRE PHOTO légende

## Données

On peut placer les deux fichiers l'un à côté de l'autre. Ouvrir dans QGIS le fichier GPKG seulement.

* [L'agglomération de Montpellier](./media/agglo_montpellier.gpkg) d'OpenStreetMap
* [Fichier tableur avec les populations](./media/base_cc_comparateur.ods) de l'INSEE

## Objectif



```python

from pathlib import Path

layer = iface.activeLayer()

parent_folder = Path(layer.source()).parent

print(parent_folder)

fichier_ods = parent_folder / "base_cc_comparateur.ods"
print(fichier_ods.is_file())

tableur = QgsVectorLayer(str(fichier_ods), "tableur", "ogr")
print(tableur.isValid())


```
