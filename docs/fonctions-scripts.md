# Organisation du code dans un script avec des fonctions

## Communication avec l'utilisateur des erreurs et des logs

Avant de commencer à vraiment écrire un script avec des fonctions, regardons comment communiquer des 
informations à l'utilisateur.

### La barre de message

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

On peut voir dans la classe de [QgsMessageBar](https://qgis.org/pyqgis/master/gui/QgsMessageBar.html#qgis.gui.QgsMessageBar.pushSuccess)
qu'il existe aussi `pushSuccess` qui est une alternative par exemple.

### Journal des logs

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

## Des fonctions pour simplifier le code

### Une fonction pour charger UNE couche

La console, c'est bien, mais c'est très limitant. Passons à l'écriture d'un script qui va nous faciliter 
l'organisation du code.

1. Redémarrer QGIS (afin de vider l'ensemble des variables que l'on a dans notre console)
1. N'ouvrez pas le projet précédent !
1. Ouvrer la console, puis cliquer sur `Afficher l'éditeur`
1. Copier/coller le script ci-dessous
1. Exécuter le

```python
# En haut du script, ce souvent des variables à modifier
bd_topo = 'BDT_3-3_SHP_LAMB93_D0ZZ-EDYYYY-MM-DD'
thematique = 'ADMINISTRATIF'
couche = 'COMMUNE'

# Puis place au script
# En théorie, pas besoin de modification, en dessous pour un "utilisateur final" du script

from pathlib import Path

projet_qgis = QgsProject.instance().absoluteFilePath()
if not projet_qgis:
    iface.messageBar().pushMessage('Erreur de chargement','Le projet n\'est pas enregistré', Qgis.Critical)
else:
    racine = Path(projet_qgis).parent
    fichier_shape = racine.joinpath(bd_topo, thematique, f'{couche}.shp')
    if not fichier_shape.exists():
        iface.messageBar().pushMessage('Erreur de chargement', f'Le chemin n\'existe pas: "{fichier_shape}"', Qgis.Critical)
    else:
        layer = QgsVectorLayer(str(fichier_shape), couche, 'ogr')
        if not layer.isValid():
            iface.messageBar().pushMessage('Erreur de chargement','La couche n\'est pas valide', Qgis.Critical)
        else:
            QgsProject.instance().addMapLayer(layer)
            iface.messageBar().pushMessage('Bravo','Well done! 👍', Qgis.Success)
    print('Fin du script si on a un projet')
```

* À l'aide du mémo Python :
  * Essayons de faire une fonction qui prend 3 paramètres :
    * la `bd_topo`
    * la `thematique`
    * le nom du shapefile `couche`
  * La fonction se chargera de faire le nécessaire, par exemple: `charger_couche(bd_topo, 'ADMINISTRATIF', 'COMMUNE')`
  * La fonction peut également retourner `False` si la couche n'est pas chargée (une erreur) ou sinon `True`

!!! tip
    Pour désindenter le code, `MAJ` + `TAB`.

```python
# Avec annotations Python
def charger_couche(bd_topo: str, thematique: str, couche: str):
    ...

# Sans annotations Python
def charger_couche(bd_topo, thematique, couche):
    ...
```

!!! tip
    Le mot-clé `pass` (ou encore `...` qui est synonyme) ne sert à rien.
    C'est un mot-clé Python pour rendre un bloc valide mais ne faisant rien.
    On peut le supprimer le bloc n'est pas vide.

On peut ajouter une **docstring** à notre fonction, juste en dessous du `def`, avec des indentations :
```python
""" Fonction qui charge une couche de la BD TOPO, selon une thématique. """
```

??? "Afficher la solution intermédiaire"
    ```python
    # En haut du script, ce souvent des variables à modifier
    bd_topo = 'BDT_3-3_SHP_LAMB93_D0ZZ-EDYYYY-MM-DD'
    thematique = 'ADMINISTRATIF'
    couche = 'COMMUNE'
    
    # Puis place au script
    # En théorie, pas besoin de modification, en dessous pour un "utilisateur final" du script
    
    from pathlib import Path

    def charger_couche(bd_topo, thematique, couche):
        """ Fonction qui charge une couche de la BD TOPO, selon une thématique. """
        projet_qgis = QgsProject.instance().absoluteFilePath()
        if not projet_qgis:
            iface.messageBar().pushMessage('Erreur de chargement','Le projet n\'est pas enregistré', Qgis.Critical)
        else:
            racine = Path(projet_qgis).parent
            fichier_shape = racine.joinpath(bd_topo, thematique, f'{couche}.shp')
            if not fichier_shape.exists():
                iface.messageBar().pushMessage('Erreur de chargement', f'Le chemin n\'existe pas: "{fichier_shape}"', Qgis.Critical)
            else:
                layer = QgsVectorLayer(str(fichier_shape), couche, 'ogr')
                if not layer.isValid():
                    iface.messageBar().pushMessage('Erreur de chargement','La couche n\'est pas valide', Qgis.Critical)
                else:
                    QgsProject.instance().addMapLayer(layer)
                    iface.messageBar().pushMessage('Bravo','Well done! 👍', Qgis.Success)
            print('Fin du script si on a un projet')
    
    # Appel de notre fonction
    charger_couche(bd_topo, thematique, couche)
    ```

Améliorons encore cette solution intermédiaire avec la gestion des erreurs avec l'instruction `return`

On peut garder le code le plus à gauche possible grâce à `return` qui ordonne la sortie de la fonction.

??? "Afficher une des solutions finales"
    ```python
    # En haut du script, ce souvent des variables à modifier
    bd_topo = 'BDT_3-3_SHP_LAMB93_D0ZZ-EDYYYY-MM-DD'

    # Puis place au script
    # En théorie, pas besoin de modification, en dessous pour un "utilisateur final" du script
    
    from pathlib import Path
    
    def charger_couche(bd_topo, thematique, couche):
        """ Fonction qui charge une couche de la BD TOPO, selon une thématique. """
        projet_qgis = QgsProject.instance().absoluteFilePath()
        if not projet_qgis:
            iface.messageBar().pushMessage('Erreur de chargement','Le projet n\'est pas enregistré', Qgis.Critical)
            return False

        racine = Path(projet_qgis).parent
        fichier_shape = racine.joinpath(bd_topo, thematique, f'{couche}.shp')
        if not fichier_shape.exists():
            iface.messageBar().pushMessage('Erreur de chargement','Le chemin n\'existe pas: "{fichier_shape}"', Qgis.Critical)
            return False
            
        layer = QgsVectorLayer(str(fichier_shape), couche, 'ogr')
        if not layer.isValid():
            iface.messageBar().pushMessage('Erreur de chargement','La couche n\'est pas valide', Qgis.Critical)
            return False

        QgsProject.instance().addMapLayer(layer)
        iface.messageBar().pushMessage('Bravo','Well done! 👍', Qgis.Success)
        # return True
        return layer
    
    # Appel de notre fonction
    charger_couche(bd_topo, 'ADMINISTRATIF', 'COMMUNE')
    charger_couche(bd_topo, 'ADMINISTRATIF', 'ARRONDISSEMENT')
    ```

### Une fonction pour lister LES couches d'UNE thématique

Essayons de faire une fonction qui liste les shapefiles d'une certaine thématique 🚀

Plus précisément, on souhaite une liste de chaînes de caractères : `['COMMUNE', 'EPCI']`.

Dans l'objet `Path`, il existe une méthode `iterdir()`. Par exemple, pour itérer sur le dossier **courant**
de l'utilisateur :

```python
from pathlib import Path

dossier = Path.home()
for fichier in dossier.iterdir():
    print(fichier)
```

!!! tip
    Il faut se référer à la documentation du module [pathlib](https://docs.python.org/3/library/pathlib.html)
    pour comprendre le fonctionnement de cette classe.

Voici la signature de la fonction que l'on souhaite :

```python
def liste_shapefiles(bd_topo: str, thematique: str):
    """ Lister les shapefiles d'une thématique dans la BDTopo. """
    ...
```

Petit mémo pour cet exercice :

* L'extension d'un fichier de type `Path` : `fichier.suffix`
* Obtenir le nom du fichier d'un objet `Path` : `fichier.stem`
* Passer une chaîne de caractère en minuscule : `"bONjouR".lower()`, pratique pour vérifier la casse 😉
* Créer une liste vide `shapes = []`
* Ajouter un élément dans une liste `shapes.append("Bonjour")`
* À la fin, on peut retourner la liste `return shapes`

??? "Correction"
    ```python
    def liste_shapefiles(bd_topo: str, thematique: str):
        """ Lister les shapefiles d'une thématique dans la BDTopo. """
        racine = Path(QgsProject.instance().absoluteFilePath()).parent
        dossier = racine.joinpath(bd_topo, thematique)
        shapes = []
        for file in dossier.iterdir():
            if file.suffix.lower() == '.shp':
                shapes.append(file.stem)
        return shapes
    
    shapes = liste_shapefiles(bd_topo, 'ADMINISTRATIF')
    print(shapes)
    ```

On a désormais **deux** fonctions : `liste_shapefiles` et `charger_couche`.

Il est désormais simple de charger **toutes** une thématique de notre BDTopo :

```python
thematique = 'ADMINISTRATIF'
shapes = liste_shapesfiles(bd_topo, thematique)
for shape in shapes:
    charger_couche(bd_topo, thematique, shape)
```

!!! success
    On a terminé avec ces deux fonctions, c'était pour manipuler les fonctions 😎

### Pour les curieux 🤭

Zoomer sur l'emprise d'une couche, sans la charger dans la légende

??? example
    1. Modifions la signature de la fonction, en ajoutant un booléen si on souhaite la couche dans la légende :
    ```python
    def charger_couche(bd_topo, thematique, couche, ajouter_dans_legende = True):
    ```
    Puis dans cette même fonction, utilisons cette variable :
    ```python
    if ajouter_dans_legende:
        QgsProject.instance().addMapLayer(layer)
        iface.messageBar().pushMessage('Bravo','Well done! 👍', Qgis.Success)
    # return True
    return layer
    ```

    Puis on peut ordonner au `QgsMapCanvas` de zoomer sur une emprise :
    ```python
    hydro = charger_couche(bd_topo, 'ZONES_REGLEMENTEES', 'PARC_OU_RESERVE', False)
    iface.mapCanvas().setExtent(hydro.extent())
    ```

    Ne pas oublier de tenir compte d'une projection différente entre le canevas et la couche.

    _TODO, à adapter, mais le code est la pour faire une reprojection entre 2 CRS_
    ```python
    extent = iface.activeLayer().extent()
    crs_layer = iface.activeLayer().crs()
    crs = iface.mapCanvas().mapSettings().destinationCrs()
    transformer = QgsCoordinateTransform(crs_layer, crs, QgsProject.instance())
    new_extent = transformer.transform(extent)
    iface.mapCanvas().setExtent(new_extent)
    ```

## Extraction des informations sous forme d'un fichier CSV.

### Introduction

On souhaite désormais réaliser une fonction d'export des métadonnées de nos couches au format CSV, avec des tabulations
comme séparateur et son CSVT.

Il existe déjà un module CSV dans Python pour nous aider à écrire un fichier de type CSV, mais nous n'allons
pas l'utiliser.

Nous allons plutôt utiliser l'API QGIS pour :

1. Créer une nouvelle couche en mémoire comportant les différentes informations que l'on souhaite exporter
2. Puis, nous allons utiliser l'API pour exporter cette couche mémoire au format CSV (l'équivalent dans QGIS de
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

### Petit mémo avec des exemples

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

Obtenir le dossier du projet actuel :
```python
projet_qgis = Path(QgsProject.instance().fileName())
dossier_qgis = projet_qgis.parent
```

Afficher la géométrie, sous sa forme "humaine", en chaîne de caractère, avec l'aide de
[`QgsWkbTypes`](https://qgis.org/pyqgis/3.34/core/QgsWkbTypes.html#qgis.core.QgsWkbTypes.geometryDisplayString) :
```python
QgsWkbTypes.geometryDisplayString(vector_layer.geometryType())
```

Pour utiliser une session d'édition, on peut faire :
```python
layer.startEditing()  # Début de la session
layer.commitChanges()  # Fin de la session en enregistrant
layer.rollback()  # Fin de la session en annulant les modifications
```

### Les contextes Python

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

### Petit mémo des classes

Nous allons avoir besoin de plusieurs classes dans l'API QGIS : 

* `QgsProject` : [PyQGIS](https://qgis.org/pyqgis/master/core/QgsProject.html) / [CPP](https://api.qgis.org/api/classQgsProject.html)
* `QgsVectorLayer` : [PyQGIS](https://qgis.org/pyqgis/master/core/QgsVectorLayer.html) / [CPP](https://api.qgis.org/api/classQgsVectorLayer.html)
* Enregistrer un fichier avec `QgsVectorFileWriter` : [PyQGIS](https://qgis.org/pyqgis/master/core/QgsVectorFileWriter.html) / [CPP](https://api.qgis.org/api/classQgsVectorFileWriter.html)
* Un champ dans une couche vecteur : `QgsField` ([PyQGIS](https://qgis.org/pyqgis/master/core/QgsField.html) / [CPP](https://api.qgis.org/api/classQgsField.html)),
  attention à ne pas confondre avec `QgsFields` ([PyQGIS](https://qgis.org/pyqgis/master/core/QgsFields.html) / [CPP](https://api.qgis.org/api/classQgsFields.html))
  qui lui représente un ensemble de champs.
* Une entité `QgsFeature` [PyQGIS](https://qgis.org/pyqgis/master/core/QgsFeature.html) / [CPP](https://api.qgis.org/api/classQgsFeature.html)
* Pour le type de géométrie : Utiliser `QgsVectorLayer` `geometryType()` et également la méthode `QgsWkbTypes.geometryDisplayString()` pour sa conversion en chaîne "lisible"
   * [PyQGIS](https://qgis.org/pyqgis/master/core/QgsWkbTypes.html) / [CPP](https://api.qgis.org/api/classQgsWkbTypes.html)

Pour le type de champ, on va avoir besoin de l'API Qt également :

* [Documentation Qt5 sur QMetaType](https://doc.qt.io/qt-5/qmetatype.html#Type-enum)
* Remplacer `QMetaType` par `QVariant` et aussi exception `QString` par `String`
* Par exemple :
    * Pour créer un nouveau champ de type string : `QgsField('nom', QVariant.String)`
    * Pour créer un nouveau champ de type entier : `QgsField('nombre_entité', QVariant.Int)`

!!! note
    Note perso, je pense qu'avec la migration vers [Qt6](./migration-majeure.md), cela va pouvoir se simplifier un peu
    pour les `QVariant`...

### Étapes

Il va y avoir plusieurs étapes dans ce script :

1. Créer une couche en mémoire
1. Ajouter des champs à cette couche en utilisant une session d'édition
1. Récupérer la liste des couches présentes dans la légende
1. Itérer sur les couches pour ajouter ligne par ligne les métadonnées dans une session d'édition
1. Enregistrer en CSV la couche mémoire

!!! tip
    Pour déboguer, on peut afficher la couche mémoire en question avec `QgsProject.instance().addMapLayer(layer_info)`

### Solution possible

```python
from qgis.core import edit

# Création de la couche mémoire
layer_info = QgsVectorLayer('None', 'info', 'memory')
# QgsProject.instance().addMapLayer(layer_info)

# Ajout des champs
with edit(layer_info):
    layer_info.addAttribute(QgsField('nom', QVariant.String))
    layer_info.addAttribute(QgsField('type', QVariant.String))
    layer_info.addAttribute(QgsField('projection', QVariant.String))
    layer_info.addAttribute(QgsField('nombre_entité', QVariant.Int))
    layer_info.addAttribute(QgsField('encodage', QVariant.String))
    layer_info.addAttribute(QgsField('seuil', QVariant.Bool))
    layer_info.addAttribute(QgsField('source', QVariant.String))

layers = QgsProject.instance().mapLayers()
if not layers:
    iface.messageBar().pushMessage('Pas de couche', "Attention, il n'a pas de couche", Qgis.Warning)

# Itération sur l'ensemble des couches du projet
for layer in layers.values():
    feature = QgsFeature(layer_info.fields())
    feature['nom'] = layer.name()
    feature['type'] = QgsWkbTypes.geometryDisplayString(layer.geometryType())
    feature['nombre_entité'] = layer.featureCount()
    feature['encodage'] = layer.dataProvider().encoding()
    feature['projection'] = layer.crs().authid()
    feature['seuil'] = layer.hasScaleBasedVisibility()
    feature['source'] = layer.publicSource()

    with edit(layer_info):
        layer_info.addFeature(feature)

# Export de la couche mémoire au format CSV
options = QgsVectorFileWriter.SaveVectorOptions()
options.driverName = 'CSV'
options.fileEncoding = 'UTF-8'
options.layerOptions = ['CREATE_CSVT=YES', 'SEPARATOR=TAB']

base_name = QgsProject.instance().baseName()
racine = Path(QgsProject.instance().absoluteFilePath()).parent
output_file = racine.joinpath(f'{base_name}.csv')

QgsVectorFileWriter.writeAsVectorFormatV3(
    layer_info,
    str(output_file),
    QgsProject.instance().transformContext(),
    options,
)

```

!!! warning
    Ajouter une couche raster et retester le script ... surprise 🎁

??? note "Pour les experts, ajouter un alias ou un commentaire sur un champ"
    ```python
    field = QgsField(
        'seuil_visibilite',
        QVariant.Bool,
        comment="Champ contenant le seuil de visibilité")
    field.setAlias("Seuil de visibilité")
    layer_info.addAttribute(field)
    ```
    Ceci dit, cela dépend dans quel format on exporte la couche, dans l'exercice, on fait du CSV, donc on perd ces
    informations.

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

Pour s'en rendre compte, on peut inclure un `print()` autour du `QgsVectorFileWriter.writeAsVectorFormatV3()`.

**De plus**, en cas de succès, il est pratique d'avertir l'utilisateur. On peut aussi fournir un lien pour ouvrir
l'explorateur de fichier :

```python
# Affichage d'un message à l'utilisateur
iface.messageBar().pushSuccess(
    "Export OK des couches 👍",
    (
        "Le fichier CSV a été enregistré dans "
        "<a href=\"{}\">{}</a>"
    ).format(output_file.parent, output_file)
)
```
