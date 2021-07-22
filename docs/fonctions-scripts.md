# Organisation du code dans un script avec des fonctions

## Communication avec l'utilisateur des erreurs et des logs

Avant de commencer à vraiment écrire un script avec des fonctions, regardons comment communiquer des 
informations à l'utilisateur.

On peut envoyer des messages vers l'utilisateur avec l'utilisation de la `messageBar` :

```Python
iface.messageBar().pushMessage('Erreur','On peut afficher une erreur', Qgis.Critical)
iface.messageBar().pushMessage('Avertissement','ou un avertissement', Qgis.Warning)
iface.messageBar().pushMessage('Information','ou une information', Qgis.Info)
iface.messageBar().pushMessage('Succès','ou un succès', Qgis.Success)
```

On peut aussi écrire des logs comme ceci (plus discret, mais plus verbeux) :
```Python
QgsMessageLog.logMessage('Une erreur est survenue','Notre outil', Qgis.Critical)
QgsMessageLog.logMessage('Un avertissement','Notre outil', Qgis.Warning)
QgsMessageLog.logMessage('Une information','Notre outil', Qgis.Info)
QgsMessageLog.logMessage('Un succès','Notre outil', Qgis.Success)
```

## Charger automatiquement plusieurs couches à l'aide d'un script

La console c'est bien, mais c'est très limitant. Passons à l'écriture d'un script qui va nous faciliter 
l'organisation du code.

Voici le dernier script du fichier précédent, mais avec la gestion des erreurs :

* Redémarrer QGIS
* N'ouvrez pas le projet précédent
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

* À l'aide du mémo Python :
  * Essayons de faire une fonction qui prend 2 paramètres
    * la thématique (le dossier)
    * le nom du shapefile
  * La fonction se chargera de faire le nécessaire, par exemple: `charger_couche('H_OSM_ADMINISTRATIF', 'COMMUNE')`
  * La fonction peut également retourner `False` si la couche n'est pas chargée (une erreur) ou sinon l'objet couche.

```python
def charger_couche(thematique, couche):
    pass
```

!!! tip
    Le mot-clé `pass` ne sert à rien. C'est un mot-clé Python pour rendre un bloc valide mais ne faisant rien.
    On peut le supprimer le bloc n'est pas vide.

* Une des solutions :

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

* Essayons de faire une fonction qui liste les shapefiles d'une certaine thématique.
  `os.walk(path)` permet de parcourir un chemin.

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

* Permettre le chargement automatique de toute une thématique.

## Extraction des informations sous forme d'un fichier CSV.

On souhaite désormais réaliser une fonction d'export des métadonnées de nos couches au format CSV, avec son
CSVT.
Il existe déjà un module CSV dans Python pour nous aider à écrire un fichier de type CSV, mais nous n'allons
pas l'utiliser.
Nous allons plutôt utiliser l'API QGIS pour créer une nouvelle couche en mémoire comportant les différentes
informations que l'on souhaite exporter.
Puis nous allons utiliser l'API pour exporter cette couche mémoire au format CSV (l'équivalent dans QGIS de
l'action `Exporter la couche`).

Les différents champs qui devront être exportés sont :

* son nom
* son type de géométrie (format humain, lisible)
* la projection
* le nombre d'entité
* l'encodage
* si le seuil de visibilité est activé
* la source (le chemin) de la donnée

Exemple de sortie : 

| nom      | type  | projection  | nombre_entite | encodage | source          | seuil_de_visibilite |
|----------|-------|-------------|---------------|----------|-----------------|---------------------|
| couche_1 | Line  | EPSG:4326   | 5             | UTF-8    | /tmp/...geojson | False               |
| couche_2 | Point | No geometry | 0             |          | /tmp/...shp     | True                |

Pour créer une couche tabulaire en mémoire :
```python
layer_info = QgsVectorLayer('None', 'info', 'memory')
```

La liste des couches :
```python
layers = QgsProject.instance().mapLayers()
```

Nous allons avoir besoin de plusieurs classes dans l'API QGIS : 

* Enregistrer un fichier : la classe `QgsVectorFileWriter`
* Un champ : `QgsField`
* Une entité : `QgsFeature`

Pour le type de champ, on va avoir besoin de l'API Qt également :

* https://doc.qt.io/qt-5/qmetatype.html#Type-enum
* Remplacer `QMetaType` par `QVariant`
* Par exemple, pour créer un nouveau champ de type entier : `QgsField('nombre_entité', QVariant.Int)`

Il va y avoir plusieurs étapes dans ce script :

1. Créer une couche en mémoire
1. Ajouter des champs à cette couche en utilisant une session d'édition
1. Récupérer la liste des couches présentes dans la légende
1. Itérer sur les couches pour ajouter ligne par ligne les métadonnées dans une session d'édition
1. Enregistrer en CSV la couche mémoire

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
        feature = QgsFeature(layer_info.fields())
        feature.setAttribute("nom", layer.name())
        feature.setAttribute("projection", layer.crs().authid())
        feature.setAttribute("nombre_entite", layer.featureCount())
        feature.setAttribute("source", layer.source())
        feature.setAttribute("type", QgsWkbTypes.geometryDisplayString(layer.geometryType()))
        feature.setAttribute("seuil_visibilite", layer.hasScaleBasedVisibility())
        layer_info.addFeature(feature)

QgsVectorFileWriter.writeAsVectorFormat(
    layer_info,
    join(QgsProject.instance().homePath(), 'test.csv'),
    'utf-8',
    QgsCoordinateReferenceSystem(),
    'CSV',
    layerOptions=['CREATE_CSVT=YES']
)

# Afficher une messageBar pour confirmer que c'est OK, en vert ;-)

```
