# Organisation du code dans un script avec des fonctions

## Communication avec l'utilisateur des erreurs et des logs

Avant de commencer à vraiment écrire un script avec des fonctions, regardons comment communiquer des 
informations à l'utilisateur.

On peut envoyer des messages vers l'utilisateur avec l'utilisation de la `messageBar` de la classe
[QgisInterface](https://qgis.org/api/classQgisInterface.html) :

```Python
iface.messageBar().pushMessage('Erreur','On peut afficher une erreur', Qgis.Critical)
iface.messageBar().pushMessage('Avertissement','ou un avertissement', Qgis.Warning)
iface.messageBar().pushMessage('Information','ou une information', Qgis.Info)
iface.messageBar().pushMessage('Succès','ou un succès', Qgis.Success)
```

Cette fonction prend 3 paramètres :

- un titre
- un message
- un niveau d'alerte

On peut aussi écrire des logs comme ceci (plus discret, mais plus verbeux) :
```Python
QgsMessageLog.logMessage('Une erreur est survenue','Notre outil', Qgis.Critical)
QgsMessageLog.logMessage('Un avertissement','Notre outil', Qgis.Warning)
QgsMessageLog.logMessage('Une information','Notre outil', Qgis.Info)
QgsMessageLog.logMessage('Un succès','Notre outil', Qgis.Success)
```

Cette fonction prend 3 paramètres :

- un message
- une catégorie, souvent le nom de l'extension ou de l'outil en question
- un niveau d'alerte

## Charger automatiquement plusieurs couches à l'aide d'un script

La console, c'est bien, mais c'est très limitant. Passons à l'écriture d'un script qui va nous faciliter 
l'organisation du code.

Ci-dessous, voici le dernier script du chapitre précédent, mais avec la gestion des erreurs ci-dessus :

* Redémarrer QGIS
* N'ouvrez pas le projet précédent
* Ouvrer la console, puis cliquer sur `Afficher l'éditeur`
* Copier/coller le script ci-dessous
* Exécuter le

```python
from os.path import join, isfile, isdir
dossier = 'BDT_3-3_SHP_LAMB93_D0ZZ-EDYYYY-MM-DD'
thematique = 'ADMINISTRATIF'
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
  * La fonction se chargera de faire le nécessaire, par exemple: `charger_couche('ADMINISTRATIF', 'COMMUNE')`
  * La fonction peut également retourner `False` si la couche n'est pas chargée (une erreur) ou sinon l'objet couche.

```python
def charger_couche(thematique, couche):
    pass
```

!!! tip
    Le mot-clé `pass` ne sert à rien. C'est un mot-clé Python pour rendre un bloc valide mais ne faisant rien.
    On peut le supprimer le bloc n'est pas vide.

??? "Afficher la solution intermédiaire"
    ```python
    from os.path import join, isfile, isdir
    dossier = 'BDT_3-3_SHP_LAMB93_D0ZZ-EDYYYY-MM-DD'
    
    
    def charger_couche(thematique, couche):
        """Fonction qui charge une couche shapefile dans une thématique."""
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
    
    thematique = 'ADMINISTRATIF'
    couche = 'COMMUNE'
    charger_couche(thematique, couche)
    ```

Améliorons encore cette solution intermédiaire avec la gestion des erreurs et aussi en gardant le code le
plus à gauche possible grâce à l'instruction `return` qui ordonne la sortie de la fonction.

??? "Afficher une des solutions finales"
    ```python
    from os.path import join, isfile, isdir
    
    def charger_couche(thematique, couche):
        """Fonction qui charge une couche shapefile dans une thématique."""
        dossier = 'BDT_3-3_SHP_LAMB93_D0ZZ-EDYYYY-MM-DD'
    
        racine = QgsProject.instance().homePath()
        if not racine:
            iface.messageBar().pushMessage('Erreur de chargement','Le projet n\'est pas enregistré', Qgis.Critical)
            return False
            
        fichier_shape = join(racine, dossier, thematique, '{}.shp'.format(couche))
        if not isfile(fichier_shape):
            iface.messageBar().pushMessage('Erreur de chargement','Le chemin n\'existe pas: "{}"'.format(fichier_shape), Qgis.Critical)
            return False
            
        layer = QgsVectorLayer(fichier_shape, couche, 'ogr')
        if not layer.isValid():
            iface.messageBar().pushMessage('Erreur de chargement','La couche n\'est pas valide', Qgis.Critical)
            return False
    
        QgsProject.instance().addMapLayer(layer)
        iface.messageBar().pushMessage('Bravo','Well done!', Qgis.Success)
        return layer
    
    charger_couche('ADMINISTRATIF', 'COMMUNE')
    charger_couche('ADMINISTRATIF', 'ARRONDISSEMENT')
    ```

* Essayons de faire une fonction qui liste les shapefiles d'une certaine thématique.

On peut utiliser la méthode [os.walk(path)](https://docs.python.org/3/library/os.html#os.walk) permet de
parcourir un chemin et de lister les répertoires et les fichiers.

Ou alors on peut utiliser une autre méthode, un peu plus à la mode en utilisant le mode
[pathlib](https://docs.python.org/3/library/pathlib.html#module-pathlib) qui comporte également les fonctions
`isfile`, `isdir` etc.

En utilisant le module `os.walk`, un peu historique :

```python
import os

def liste_shapefiles(thematique):
    """Liste les shapefiles d'une thématique."""
    dossier = 'BDT_3-3_SHP_LAMB93_D0ZZ-EDYYYY-MM-DD'
    racine = QgsProject.instance().homePath()
    shapes = []
    for root, directories, files in os.walk(os.path.join(racine, dossier, thematique)):
        for file in files:
            if file.lower().endswith('.shp'):
                shapes.append(file.replace('.shp', ''))
    return shapes

shapes = liste_shapefiles('ADMINISTRATIF')
print(shapes)
```

En utilisant le "nouveau" module `pathlib`:

```python
from pathlib import Path

def liste_shapefiles(thematique):
    """Liste les shapefiles d'une thématique."""
    racine = QgsProject.instance().homePath()
    dossier = Path(racine).joinpath('BDT_3-3_SHP_LAMB93_D0ZZ-EDYYYY-MM-DD', thematique)
    shapes = []
    for file in dossier.iterdir():
        if file.suffix.lower() == '.shp':
            shapes.append(file.stem)
    return shapes

shapes = liste_shapefiles('ADMINISTRATIF')
print(shapes)
```

!!! tip
    Il faut se référer à la documentation du module [pathlib](https://docs.python.org/3/library/pathlib.html)
    pour comprendre le fonctionnement de cette classe.

* Permettre le chargement automatique de toute une thématique.

??? "Afficher la solution complète"
    ```python
    import os
    from os.path import join, isfile, isdir
    dossier = 'BDT_3-3_SHP_LAMB93_D0ZZ-EDYYYY-MM-DD'
    # couche = 'COMMUNE'
    
    def liste_shapesfiles(thematique):
        """Liste les shapes d'une thématique"""
        racine = QgsProject.instance().homePath()
        if not racine:
            iface.messageBar().pushMessage('Erreur de chargement','Le projet n\'est pas enregistré', Qgis.Critical)
            return False
        
        shapes = []
        for root, directories, files in os.walk(os.path.join(racine, dossier, thematique)):
            # print(files)
            for file in files:
                # print(file)
                if file.lower().endswith('.shp'):
                    # print(file)
                    shapes.append(file.replace(".shp", ""))
        
        return shapes
    
    def charger_couche(thematique, couche):
        
        """Fonction qui charge des couches suivant une thématique."""
        racine = QgsProject.instance().homePath()
        if not racine:
            iface.messageBar().pushMessage('Erreur de chargement','Le projet n\'est pas enregistré', Qgis.Critical)
            return False
    
        fichier_shape = join(racine, dossier, thematique, '{}.shp'.format(couche))
        if not isfile(fichier_shape):
            iface.messageBar().pushMessage('Erreur de chargement','Le chemin n\'existe pas: "{}"'.format(fichier_shape), Qgis.Critical)
            return False
    
        layer = QgsVectorLayer(fichier_shape, couche, 'ogr')
        if not layer.isValid():
            iface.messageBar().pushMessage('Erreur de chargement','La couche n\'est pas valide', Qgis.Critical)
            return False
            
        QgsProject.instance().addMapLayer(layer)
        iface.messageBar().pushMessage('Bravo','Well done!', Qgis.Success)
        return layer
    
    
    thematique = 'ADMINISTRATIF'
    shapes = liste_shapesfiles(thematique)
    for shape in shapes:
        charger_couche(thematique, shape)
    ```

## Extraction des informations sous forme d'un fichier CSV.

On souhaite désormais réaliser une fonction d'export des métadonnées de nos couches au format CSV, avec son
CSVT.
Il existe déjà un module CSV dans Python pour nous aider à écrire un fichier de type CSV, mais nous n'allons
pas l'utiliser.
Nous allons plutôt utiliser l'API QGIS pour créer une nouvelle couche en mémoire comportant les différentes
informations que l'on souhaite exporter.
Puis, nous allons utiliser l'API pour exporter cette couche mémoire au format CSV (l'équivalent dans QGIS de
l'action `Exporter la couche`).

Les différents champs qui devront être exportés sont :

* son nom
* son type de géométrie (format humain, lisible)
* la projection
* le nombre d'entité
* l'encodage
* si le seuil de visibilité est activé
* la source (le chemin) de la donnée

### Exemple de sortie 

| nom      | type  | projection  | nombre_entite | encodage | source          | seuil_de_visibilite |
|----------|-------|-------------|---------------|----------|-----------------|---------------------|
| couche_1 | Line  | EPSG:4326   | 5             | UTF-8    | /tmp/...geojson | False               |
| couche_2 | Tab   | No geometry | 0             |          | /tmp/...shp     | True                |

### Petit mémo

Pour créer une couche tabulaire en mémoire, [code qui vient du cookbook](https://docs.qgis.org/latest/fr/docs/pyqgis_developer_cookbook/vector.html) :
```python
layer_info = QgsVectorLayer('None', 'info', 'memory')
```

La liste des couches :
```python
layers = QgsProject.instance().mapLayers()
```

Créer une entité ayant déjà les champs préconfigurés d'une couche vecteur, et y affecter des valeurs :
```python
feature = QgsFeature(objet_qgsvectorlayer.fields())
feature['nom'] = "NOM"
```

Pour utiliser une session d'édition, on peut faire :
```python
layer.startEditing()  # Début de la session
layer.commitChanges()  # Fin de la session en enregistrant
layer.rollback()  # Fin de la session en annulant les modifications
```

On peut également faire une session d'édition avec un
"[contexte Python](https://www.pythoniste.fr/python/les-gestionnaires-de-contexte-et-linstruction-with-en-python/)" :

```python
from qgis.core import edit

with edit(layer):
    # Faire une édition sur la couche
    pass

# À la fin du bloc d'indentation, la session d'édition est automatiquement close, même en cas d'erreur Python
```

??? "Exemple de l'utilisation d'un contexte Python avec la session d'édition"
    Sans contexte, la couche reste en mode édition en cas d'erreur fatale Python

    ```python
    layer = iface.activeLayer()

    layer.startEditing()

    # Code inutile, mais qui va volontairement faire une exception Python
    a = 10 / 0

    layer.commitChanges()
    print("Fin du script")
    ```

    Mais utilisons désormais un contexte Python à l'aide de`with`, sur une couche qui n'est pas en édition :

    ```python
    layer = iface.activeLayer()

    with edit(layer):
        # Code inutile, mais qui va volontairement faire une exception Python
        a = 10 / 0

    print("Fin du script")
    ```

    On peut lire le code comme `En éditant la couche "layer", faire :`.


Nous allons avoir besoin de plusieurs classes dans l'API QGIS : 

* `QgsProject` : [PyQGIS](https://qgis.org/pyqgis/master/core/QgsProject.html) / [CPP](https://api.qgis.org/api/classQgsProject.html)
* Enregistrer un fichier avec `QgsVectorFileWriter` : [PyQGIS](https://qgis.org/pyqgis/master/core/QgsVectorFileWriter.html) / [CPP](https://api.qgis.org/api/classQgsVectorFileWriter.html)
* Un champ : `QgsField` ([PyQGIS](https://qgis.org/pyqgis/master/core/QgsField.html) / [CPP](https://api.qgis.org/api/classQgsField.html)),
  attention à ne pas confondre avec `QgsFields` ([PyQGIS](https://qgis.org/pyqgis/master/core/QgsFields.html) / [CPP](https://api.qgis.org/api/classQgsFields.html))
  qui lui représente un ensemble de champs.
* Une entité `QgsFeature` [PyQGIS](https://qgis.org/pyqgis/master/core/QgsFeature.html) / [CPP](https://api.qgis.org/api/classQgsFeature.html)
* Pour le type de géométrie : Utiliser `QgsVectorLayer::geometryType()` et également la méthode `QgsWkbTypes::geometryDisplayString()` pour sa conversion en chaîne "lisible"

Pour le type de champ, on va avoir besoin de l'API Qt également :

* [Documentation Qt5 sur QMetaType](https://doc.qt.io/qt-5/qmetatype.html#Type-enum)
* Remplacer `QMetaType` par `QVariant` et aussi exception `QString` par `String`
* Par exemple :
    * Pour créer un nouveau champ de type string : `QgsField('nom', QVariant.String)`
    * Pour créer un nouveau champ de type entier : `QgsField('nombre_entité', QVariant.Int)`

Il va y avoir plusieurs étapes dans ce script :

1. Créer une couche en mémoire
1. Ajouter des champs à cette couche en utilisant une session d'édition
1. Récupérer la liste des couches présentes dans la légende
1. Itérer sur les couches pour ajouter ligne par ligne les métadonnées dans une session d'édition
1. Enregistrer en CSV la couche mémoire


!!! tip
    Pour déboguer, on peut afficher la couche mémoire en question avec `QgsProject.instance().addMapLayer()`
    
### Solution

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
        feature.setAttribute("encodage", layer.dataProvider().encoding())
        feature.setAttribute("source", layer.source())
        feature.setAttribute("type", QgsWkbTypes.geometryDisplayString(layer.geometryType()))
        feature.setAttribute("seuil_visibilite", layer.hasScaleBasedVisibility())
        layer_info.addFeature(feature)

base_name = QgsProject.instance().baseName()
QgsVectorFileWriter.writeAsVectorFormat(
    layer_info,
    join(QgsProject.instance().homePath(), f'{base_name}.csv'),
    'utf-8',
    QgsCoordinateReferenceSystem(),
    'CSV',
    layerOptions=['CREATE_CSVT=YES']
)

# Afficher une messageBar pour confirmer que c'est OK, en vert ;-)

```

??? "Pour la version avec `writeAsVectorFormatV3`"
    Il faut désormais donner le contexte pour une éventuelle reprojection que l'on trouve dans la classe
    **QgsProject** : `QgsProject.instance().transformContext()`.

    L'ensemble des options se donne via une nouvelle variable `QgsVectorFileWriter.SaveVectorOptions()`.

    ```python
    options = QgsVectorFileWriter.SaveVectorOptions()
    options.driverName = 'CSV'
    options.fileEncoding = 'UTF-8'
    options.layerOptions = ['CREATE_CSVT=YES', 'SEPARATOR=TAB']

    base_name = QgsProject.instance().baseName()
    QgsVectorFileWriter.writeAsVectorFormatV3(
        layer_info,
        join(QgsProject.instance().homePath(), f'{base_name}.csv'),
        QgsProject.instance().transformContext(),
        options,
    )
    ```

!!! warning
    Ajouter une couche raster et retester le script ... surprise 🎁

!!! tip
    Pour obtenir en Python la liste des fournisseurs GDAL/OGR :
    ```python
    from osgeo import ogr
    [ogr.GetDriver(i).GetDescription() for i in range(ogr.GetDriverCount())]    
    ```
    ou dans le menu Préférences ➡ Options ➡ GDAL ➡ Pilotes vecteurs

### Finalisation

Idéalement, il faut vérifier le résultat de l'enregistrement du fichier. Les différentes méthodes `writeAsVectorFormat`
retournent systématiquement un tuple avec un code d'erreur et un message si nécessaire, voir la
[documentation](https://api.qgis.org/api/classQgsVectorFileWriter.html#a3a4405a59d8f8ac147878cae5bd9bade).

En cas de succès, il est pratique d'avertir l'utilisateur. On peut aussi fournir un lien pour ouvrir l'explorateur de fichier :

```python
base_name = QgsProject.instance().baseName()
output_file = Path(QgsProject.instance().homePath()).joinpath(f'{base_name}.csv')
iface.messageBar().pushSuccess(
    "Export OK des couches 👍",
    (
        "Le fichier CSV a été enregistré dans "
        "<a href=\"{}\">{}</a>"
    ).format(output_file.parent, output_file)
)
```

## Connection d'un signal à une fonction

Nous avons pu voir que dans la documentation des librairies **Qt** et **QGIS**, il y a une section **Signals**.

Cela sert à déclencher du code Python lorsqu'un signal est émis.

Par exemple, dans la classe `QgsMapLayer`, cherchons un signal qui est émis **après** (before) que la session d'édition
commence.

```python
variable_de_lobjet.nom_du_signal.connect(nom_de_la_fonction)
```

Note, il ne faut pas écrire `nom_de_la_fonction()` car on ne souhaite pas **appeler** la fonction, juste **connecter**.
