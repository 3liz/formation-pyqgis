# Organisation du code dans un script avec des fonctions

## Charger automatiquement plusieurs couches à l'aide d'un script

La console c'est bien, mais c'est très limitant. Passons à l'écriture d'un script qui va nous faciliter 
l'organisation du code.

Voici le dernier script du fichier précédent, mais avec la gestion des erreurs:
* Redémarrer QGIS
* N'ouvrer pas le projet précédent
* Ouvrer la console, puis cliquer sur `Afficher l'éditeur`
* Copier/coller le script ci-dessous
* Exécuter le

```python
from os.path import join, isfile, isdir
dossier = '201909_11_ILE_DE_FRANCE_SHP_L93_2154'
thematique = 'H_OSM_ADMINISTRATIF'
couche = 'COMMUNE'

racine = QgsProject.instance().homePath()
if not racine:
    iface.messageBar().pushMessage('Erreur de chargement','Le projet n\'est pas enregistré', Qgis.Critical)
else:
    fichier_shape = join(racine, dossier, thematique, '{}.shp'.format(couche))
    if not isfile(fichier_shape):
        iface.messageBar().pushMessage('Erreur de chargement','Le chemin n\'existe pas: "{}"'.format(fichier_shape), Qgis.Critical)
    else:
        layer = QgsVectorLayer(fichier_shape, couche, 'ogr')
        if not layer.isValid():
            iface.messageBar().pushMessage('Erreur de chargement','La couche n\'est pas valide', Qgis.Critical)
        else:
            QgsProject.instance().addMapLayer(layer)
            iface.messageBar().pushMessage('Bravo','Well done!', Qgis.Success)

```
* À l'aide du mémo Python:
	* Essayons de faire une fonction qui prend 2 paramètres
		* la thématique (le dossier)
		* le nom du shapefile
	* La fonction se chargera de faire le nécessaire, par exemple: `charger_couche('H_OSM_ADMINISTRATIF', 'COMMUNE')`
	* La fonction peut également retourner `False` si la couche n'est pas chargée (une erreur) ou sinon l'objet couche.

```python
def charger_couche(thematique, couche):
    pass
```
	
* Une des solutions:

```python
from os.path import join, isfile, isdir

def charger_couche(thematique, couche):
    """Fonction qui charge une couche shapefile dans une thématique."""
    dossier = '201909_11_ILE_DE_FRANCE_SHP_L93_2154'

    racine = QgsProject.instance().homePath()
    if not racine:
        iface.messageBar().pushMessage('Erreur de chargement','Le projet n\'est pas enregistré', Qgis.Critical)
        return False
        
    fichier_shape = join(racine, dossier, thematique, '{}.shp'.format(couche))
    if not isfile(fichier_shape):
        iface.messageBar().pushMessage('Erreur de chargement','Le chemin n\'existe pas: "{}"'.format(fichier_shape), Qgis.Critical)
        return False
        
    layer = QgsVectorLayer(fichier_shape, shapefile, 'ogr')
    if not layer.isValid():
        iface.messageBar().pushMessage('Erreur de chargement','La couche n\'est pas valide', Qgis.Critical)
        return False

    QgsProject.instance().addMapLayer(layer)
    iface.messageBar().pushMessage('Bravo','Well done!', Qgis.Success)
    return layer

charger_couche('H_OSM_ADMINISTRATIF', 'COMMUNE')
charger_couche('H_OSM_ADMINISTRATIF', 'ARRONDISSEMENT')
```

* Essayons de faire une fonction qui liste les shapefiles d'une certaine thématique. `os.walk(path)` permet de parcourir un chemin.

```python
import os

def liste_shapefiles(thematique):
    """Liste les shapefiles d'une thématique."""
    dossier = '201909_11_ILE_DE_FRANCE_SHP_L93_2154'
    racine = QgsProject.instance().homePath()
    shapes = []
    for root, directories, files in os.walk(os.path.join(racine, dossier, thematique)):
        for file in files:
            if file.lower().endswith('.shp'):
                shapes.append(file.replace('.shp', ''))
    return shapes

shapes = liste_shapefiles('H_OSM_ADMINISTRATIF')
print(shapes)
```

* Permettre le chargement automatique de toute un thématique.

## Extraction des informations sous forme d'un fichier CSV.

On souhaite désormais réaliser une fonction d'export des métadonnées de nos couches au format CSV, avec son CSVT.
Il existe déjà un module CSV dans Python pour nous aider à écrire un fichier de type CSV, mais nous n'allons pas l'utiliser.
Nous allons plutôt utiliser l'API QGIS pour créer une nouvelle couche en mémoire comportant les différentes informations que l'on souhaite exporter.
Puis nous allons utiliser l'API pour exporter cette couche mémoire au format CSV (l'équivalent dans QGIS de l'action `Exporter la couche`).

Les différents champs qui devront être exportés sont:
* son nom
* son type de géométrie (format humain, lisible)
* la projection
* le nombre d'entité
* l'encodage
* si le seuil de visibilité est activé
* la source (le chemin) de la donnée

Pour créer une couche tabulaire en mémoire :
```python
layer_info = QgsVectorLayer('None', 'info', 'memory')
```

La liste des couches :
```python
layers = QgsProject.instance().mapLayers()
```

Pour enregistrer un fichier : la classe `QgsVectorFileWriter`

Solution :

```python
from os.path import join

layers = QgsProject.instance().mapLayers()
if not layers:
    iface.messageBar().pushMessage('Pas de couche','Attention, il n\'a pas de couche', Qgis.Warning)

layers = [layer for layer in layers.values()]

layer_info = QgsVectorLayer('None', 'info', 'memory')

fields = []
fields.append(QgsField('nom', QVariant.String))
fields.append(QgsField('type', QVariant.String))
fields.append(QgsField('projection', QVariant.String))
fields.append(QgsField('nombre_entite', QVariant.Int))
fields.append(QgsField('encodage', QVariant.String))
fields.append(QgsField('source', QVariant.String))
fields.append(QgsField('seuil_de_visibilite', QVariant.String))

with edit(layer_info):
    for field in fields:
        layer_info.addAttribute(field)

QgsProject.instance().addMapLayer(layer_info)

with edit(layer_info):
    for layer in layers:
        feature = QgsFeature()
        attributes = [
            layer.name(),
            QgsWkbTypes.geometryDisplayString(layer.geometryType()),
            layer.crs().authid(),
            layer.featureCount(),
            layer.dataProvider().encoding(),
            layer.source(),
            str(layer.hasScaleBasedVisibility())
        ]
        feature.setAttributes(attributes)
        layer_info.addFeature(feature)

QgsVectorFileWriter.writeAsVectorFormat(
    layer_info,
    join(QgsProject.instance().homePath(), 'test.csv'),
    'utf-8',
    QgsCoordinateReferenceSystem(),
    'CSV',
    layerOptions=['CREATE_CSVT=YES']
)

```

## Communication avec l'utilisateur des erreurs et des logs

Nous avons déjà vu ci-dessus comment générer des messages vers l'utilisateur avec l'utilisation de la `messageBar` :
```Python
iface.messageBar().pushMessage('Erreur','On peut afficher une erreur', Qgis.Critical)
iface.messageBar().pushMessage('Avertissement','ou un avertissement', Qgis.Warning)
iface.messageBar().pushMessage('Information','ou une information', Qgis.Info)
iface.messageBar().pushMessage('Succès','ou un succès', Qgis.Success)
```

On peut aussi écrire des logs comme ci:
```Python
QgsMessageLog.logMessage('Une erreur est survenue','Notre outil', Qgis.Critical)
QgsMessageLog.logMessage('Un avertissement','Notre outil', Qgis.Warning)
QgsMessageLog.logMessage('Une information','Notre outil', Qgis.Info)
QgsMessageLog.logMessage('Un succès','Notre outil', Qgis.Success)
```
