# Processing

Processing est un framework pour faire des algorithmes dans QGIS.

Toute la boite à outils Traitement dans QGIS sont des basés sur "Processing".

*Note*, depuis QGIS 3.6, il existe désormais une autre syntaxe pour 
écrire script Processing à l'aide des décorateurs Python.

## Notion sur la POO en Python

Le framework Processing utilise le concept de la **P**rogrammation **O**rientée **O**bjet. Il existe un
[tutoriel](https://openclassrooms.com/fr/courses/4302126-decouvrez-la-programmation-orientee-objet-avec-python)
sur le site d'OpenClassRooms sur le sujet.

Mais depuis le début de la formation, nous l'utilisons sans trop le savoir. Les objets `Qgs*`, comme
`QgsMapLayer` utilisent le principe de la POO.

Nous allons faire un "très" petit exemple rapide. Écrivons notre premier jeu vidéo en console !

```python

from time import sleep

MAX_ENERGIE = 20


class Personnage:

    def __init__(self, nom, energie=MAX_ENERGIE):
        self.nom = nom
        self.energie = energie

    def marcher(self):
        cout = 5
        if self.energie >= cout:
            print(f"{self.nom} marche.")
            self.energie -= cout
        else:
            print(f"{self.nom} ne peut pas marcher car il n'a pas assez d'énergie.")

    def courir(self):
        cout = 10
        if self.energie >= cout:
            print(f"{self.nom} court.")
            self.energie -= cout
        else:
            print(f"{self.nom} ne peut pas courir car il n\'a pas assez d\'énergie.")

    def dormir(self):
        print(f"{self.nom} dort et fait le plein d'énergie.")
        for i in range(2):
            print('...')
            sleep(1)
        self.energie = MAX_ENERGIE

    def manger(self):
        energie = 10
        print(f"{self.nom} mange et récupère {energie} points d'énergie.")
        if self.energie <= MAX_ENERGIE - energie:
            self.energie += energie
        else:
            self.energie = MAX_ENERGIE

    def __str__(self):
        return f"Je suis {self.nom} et j'ai {self.energie} points d'énergie"


a = Personnage('Bob')
a.courir()
a.dormir()
a.manger()
print(a)

```

## Documentation

Pour l'écriture d'un script Processing, tant en utilisant la POO ou la version avec les décorateurs, il y a
une page sur la 
[documentation](https://docs.qgis.org/3.16/fr/docs/user_manual/processing/scripts.html#writing-new-processing-algorithms-as-python-scripts).

## Utiliser Processing en Python avec un algorithme existant

* Sur une couche en EPSG:2154, faire un buffer de 10 mètres par exemple.
* Cliquer sur la petite horloge dans le panneau de Processing/Traitement en haut
* Cliquer sur le dernier traitement en haut, puis copier/coller la ligne de Python

On peut appeler un traitement en ligne de commande Python :

```python
processing.run(
    "native:buffer", 
    {
        'INPUT':'/home/etienne/tmp/formation_pyqgis/202101_OSM2IGEO_11_ILE_DE_FRANCE_SHP_L93_2154/D_OSM_HYDROGRAPHIE/CANALISATION_EAU.shp',
        'DISTANCE':10,
        'SEGMENTS':5,
        'END_CAP_STYLE':0,
        'JOIN_STYLE':0,
        'MITER_LIMIT':2,
        'DISSOLVE':False,
        'OUTPUT':'TEMPORARY_OUTPUT'
    }
)
```

**Pour obtenir l'identifiant de l'algorithme, laissez la souris sur le nom de l'algorithme pour avoir son 
info-bulle dans le panneau traitement.

Lien vers la documentation : https://docs.qgis.org/testing/en/docs/user_manual/processing/console.html

Pour obtenir la description d'un algorithme :
```python
processing.algorithmHelp("native:buffer")
```

**Exercice**, faire une 3 tampons sur la même couche vecteur, distance 10, 20 et 30 mètres, avec une fonction.

```python
def tampon(distance):
    result = processing.run(
        "native:buffer", 
        {
            'INPUT':'/home/etienne/tmp/formation_pyqgis/202101_OSM2IGEO_11_ILE_DE_FRANCE_SHP_L93_2154/D_OSM_HYDROGRAPHIE/BARRAGE.shp',
            'DISTANCE':distance,
            'SEGMENTS':5,
            'END_CAP_STYLE':0,
            'JOIN_STYLE':0,
            'MITER_LIMIT':2,
            'DISSOLVE':False,
            'OUTPUT':'TEMPORARY_OUTPUT'
        }
    )
    QgsProject.instance().addMapLayer(result['OUTPUT'])
    
for x in [10, 20, 30]:
    tampon(x)
```

## Notre propre script Processing

* Nous souhaitons pouvoir créer plusieurs tables vides assez facilement à l'aide des fichiers CSV.
* Nous avons un dossier avec plusieurs fichiers CSV représentant chacun une table.
* Le nom du fichier CSV représente le nom de la table.
* La première ligne représente l'entête des colonnes.
* La deuxième ligne, si elle s'appelle `geom`, représente le type de géométrie et sa projection.

Exemple de fichier csv `canalisation.csv` : 

| name |   type   | length | precision | alias    |
|------|----------|--------|-----------|----------|
| geom | polygon  | 2154   |           |          |
| id   | 2        | 3      | 0         | ID       |
| n    | 10       | 10     | 0         | Nom      |
| d    | 2        | 3      | 0         | Diamètre |
| l    | 2        | 3      | 0         | Longueur |

### Préparation

* Créer un dossier `processing_canalisation` à côté du projet avec des fichiers CSV à l'intérieur :
  
`canalisation.csv`

```csv
name,type,length,precision,alias
geom,line,2154,'',''
id,2,3,0,ID
n,10,10,0,Nom
d,2,3,0,Diamètre
l,2,3,0,Longueur
```

`regard.csv` :

```csv
name,type,length,precision,alias
geom,point,2154,'',''
id,2,3,0,ID
n,10,10,0,Nom rue
```

### Création du coeur de notre script

* Commençons par écrire le script en console
* Il nous faut une fonction qui liste les CSV dans un dossier.

```python
def liste_csv(folder):
    """ Liste les CSV disponibles dans le dossier. """
    pass
```

Correction du script Python (et non la correction du script Processing) :

```python
import os
import csv

def liste_csv(folder):
    """ Fonction générique pour liste les CSV dans un dossier. """
    csvs = []
    for root, directories, files in os.walk(folder):
        for file in files:
            if file.lower().endswith('.csv'):
                csvs.append(os.path.join(root, file))
    return csvs

def lire_csv(csv_file):
    """ Fonction générique pour créer une couche vecteur selon la définition d'un CSV. """
    geom = 'None'
    crs = None
    fields = []
    
    with open(csv_file) as csv_file:
        reader = csv.reader(csvfile)
        for i, row in enumerate(reader):
            if i == 0:
                # Header du CSV
                continue
            elif i == 1 and row[0] == 'geom':
                geom = row[1]
                crs = row[2]
            else:
                field = QgsField()
                field.setName(row[0])
                field.setType(int(row[1]))
                field.setLength(int(row[2]))
                field.setPrecision(int(row[3]))
                field.setAlias(row[4])
                fields.append(field)
    
    name = os.path.splitext(os.path.basename(csv_file))[0]
    if geom:
        geom += '?crs=epsg:{}'.format(crs)
    layer = QgsVectorLayer(geom, name, 'memory')
    with edit(layer):
        for field in fields:
            layer.addAttribute(field)
            
    return layer

# Appel des fonctions
folder = os.path.join(QgsProject.instance().homePath(), 'processing_canalisation')
csv_files = liste_csv(folder)
for csv_file in csv_files:
    layer = lire_csv(csv_file)
    QgsProject.instance().addMapLayer(layer)

```

Nous avons le coeur de notre algorithme, qui fonctionne dans la console Python. Si l'utilisateur souhaite 
changer de thématique pour la génération des couches (ne pas utiliser `processing_canalisation` mais plutôt
`processing_fibre_optique` ou `processing_plu`), il faut qu'il modifie à la main la ligne de Python, ce n'est
pas très ergonomique.

Nous allons désormais le transformer en Script Processing afin de rajouter une interface graphique.

* Partons de l'algorithme d'exemple :
   * Panneau Traitement 
   * `Python` en haut
   * `Créer un nouveau script depuis un modèle`
* Modifions les fonctions une par une : 
   * `name()`
   * `displayName()`
   * ...

Pour le `initAlgorithm()`, nous devons modifier le paramètre pour afficher un sélecteur de dossier :

```python
    def initAlgorithm(self, config=None):
        self.addParameter(
            QgsProcessingParameterFile(
                self.INPUT,
                self.tr('Répertoire'),
                QgsProcessingParameterFile.Folder,
                optional=False
            )
        )
        
        self.addOutput(
            QgsProcessingOutputMultipleLayers(
                self.OUTPUT_LAYERS,
                self.tr('Couches de sorties')
            )
        )
```

Ajoutons les fonctions `liste_csv` et `lire_csv` mais :

* Ajoutons `self` comme premier paramètre dans la signature de la fonction : `def lire_csv(self, ...):`
* Ajoutons `self` lors de l'appel à la fonction : `self.liste_csv(...)`

Pour le `processAlgorithm`, nous allons incorporer le code que l'on a fait avant

```python
    def processAlgorithm(self, parameters, context, feedback):
        """
        Here is where the processing itself takes place.
        """
        folder = self.parameterAsFile(parameters, self.INPUT, context)
        csv_files = self.liste_csv(folder)
        
        results = []
        for csv_file in csv_files:
            layer = self.lire_csv(csv_file)
            results.append(layer.id())
            
            context.temporaryLayerStore().addMapLayer(layer)
            context.addLayerToLoadOnCompletion(
                layer.id(),
                QgsProcessingContext.LayerDetails(
                    layer.name(),
                    context.project(),
                    self.OUTPUT
                )
            )
            
        return {self.OUTPUT: results}
```

* Il faut aussi ajouter les imports manquants.

Solution finale :

```python
"""
***************************************************************************
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; either version 2 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
***************************************************************************
"""
import os
import csv

from qgis.PyQt.QtCore import QCoreApplication
from qgis.core import (
   edit,
   QgsField,
   QgsProcessingContext,
   QgsProcessingAlgorithm,
   QgsProcessingParameterFile,
   QgsProcessingOutputMultipleLayers,
   QgsVectorLayer,
)


class ExampleProcessingAlgorithm(QgsProcessingAlgorithm):
    """
    This is an example algorithm that takes a vector layer and
    creates a new identical one.

    It is meant to be used as an example of how to create your own
    algorithms and explain methods and variables used to do it. An
    algorithm like this will be available in all elements, and there
    is not need for additional work.

    All Processing algorithms should extend the QgsProcessingAlgorithm
    class.
    """

    # Constants used to refer to parameters and outputs. They will be
    # used when calling the algorithm from another algorithm, or when
    # calling from the QGIS console.

    INPUT = 'INPUT'
    OUTPUT = 'OUTPUT'

    def tr(self, string):
        """
        Returns a translatable string with the self.tr() function.
        """
        return QCoreApplication.translate('Processing', string)

    def createInstance(self):
        return ExampleProcessingAlgorithm()

    def name(self):
        """
        Returns the algorithm name, used for identifying the algorithm. This
        string should be fixed for the algorithm, and must not be localised.
        The name should be unique within each provider. Names should contain
        lowercase alphanumeric characters only and no spaces or other
        formatting characters.
        """
        return 'myscript'

    def displayName(self):
        """
        Returns the translated algorithm name, which should be used for any
        user-visible display of the algorithm name.
        """
        return self.tr('My Script')

    def group(self):
        """
        Returns the name of the group this algorithm belongs to. This string
        should be localised.
        """
        return self.tr('Example scripts')

    def groupId(self):
        """
        Returns the unique ID of the group this algorithm belongs to. This
        string should be fixed for the algorithm, and must not be localised.
        The group id should be unique within each provider. Group id should
        contain lowercase alphanumeric characters only and no spaces or other
        formatting characters.
        """
        return 'examplescripts'

    def shortHelpString(self):
        """
        Returns a localised short helper string for the algorithm. This string
        should provide a basic description about what the algorithm does and the
        parameters and outputs associated with it..
        """
        return self.tr("Example algorithm short description")

    def initAlgorithm(self, config=None):
        """
        Here we define the inputs and output of the algorithm, along
        with some other properties.
        """
        self.addParameter(
            QgsProcessingParameterFile(
                self.INPUT,
                self.tr('Répertoire'),
                QgsProcessingParameterFile.Folder,
                optional=False
            )
        )
        
        self.addOutput(
            QgsProcessingOutputMultipleLayers(
                self.OUTPUT,
                self.tr('Couches de sorties')
            )
        )

    def liste_csv(self, folder):
        """ Fonction générique pour liste les CSV dans un dossier. """
        csvs = []
        for root, directories, files in os.walk(folder):
            for file in files:
                if file.lower().endswith('.csv'):
                    csvs.append(os.path.join(root, file))
        return csvs

    def lire_csv(self, csv_file):
        """ Fonction générique pour créer une couche vecteur selon la définition d'un CSV. """
        geom = 'None'
        crs = None
        fields = []
        
        with open(csv_file) as csvfile:
            reader = csv.reader(csvfile)
            for i, row in enumerate(reader):
                if i == 0:
                    # Header du CSV
                    continue
                elif i == 1 and row[0] == 'geom':
                    geom = row[1]
                    crs = row[2]
                else:
                    field = QgsField()
                    field.setName(row[0])
                    field.setType(int(row[1]))
                    field.setLength(int(row[2]))
                    field.setPrecision(int(row[3]))
                    field.setAlias(row[4])
                    fields.append(field)
        
        name = os.path.splitext(os.path.basename(csv_file))[0]
        if geom:
            geom += '?crs=epsg:{}'.format(crs)
        layer = QgsVectorLayer(geom, name, 'memory')
        with edit(layer):
            for field in fields:
                layer.addAttribute(field)
                
        return layer

    def processAlgorithm(self, parameters, context, feedback):
        """
        Here is where the processing itself takes place.
        """
        folder = self.parameterAsFile(parameters, self.INPUT, context)
        csv_files = self.liste_csv(folder)
        
        results = []
        for csv_file in csv_files:
            layer = self.lire_csv(csv_file)
            results.append(layer.id())
            
            context.temporaryLayerStore().addMapLayer(layer)
            context.addLayerToLoadOnCompletion(
                layer.id(),
                QgsProcessingContext.LayerDetails(
                    layer.name(),
                    context.project(),
                    self.OUTPUT
                )
            )
            
        return {self.OUTPUT: results}
```
Nous avons désormais un nouveau algorithme dans la boîte à outils pour générer un modèle de données suivant 
une thématique.

### Introduction aux décorateurs

Comme mentionné au début de ce chapitre, il est possible de ne pas utiliser la POO pour écrire un Script
Processing mais plutôt les décorateurs. Reprenons l'exemple de la documentation.

Le code suivant utilise le décorateur @alg pour :

* utiliser une couche vectorielle comme entrée
* compter le nombre d'entités
* faire une opération buffer
* créer une couche raster à partir du résultat de l’opération de tampon
* renvoyer la couche tampon, la couche raster et le nombre d’entités

```python

from qgis import processing
from qgis.processing import alg


@alg(name='bufferrasteralg', label='Buffer and export to raster (alg)',
     group='examplescripts', group_label='Example scripts')
# 'INPUT' is the recommended name for the main input parameter
@alg.input(type=alg.SOURCE, name='INPUT', label='Input vector layer')
# 'OUTPUT' is the recommended name for the main output parameter
@alg.input(type=alg.RASTER_LAYER_DEST, name='OUTPUT',
           label='Raster output')
@alg.input(type=alg.VECTOR_LAYER_DEST, name='BUFFER_OUTPUT',
           label='Buffer output')
@alg.input(type=alg.DISTANCE, name='BUFFERDIST', label='BUFFER DISTANCE',
           default=1.0)
@alg.input(type=alg.DISTANCE, name='CELLSIZE', label='RASTER CELL SIZE',
           default=10.0)
@alg.output(type=alg.NUMBER, name='NUMBEROFFEATURES',
            label='Number of features processed')
def bufferrasteralg(instance, parameters, context, feedback, inputs):
   """
   Description of the algorithm.
   (If there is no comment here, you will get an error)
   """
   input_featuresource = instance.parameterAsSource(parameters,
                                                    'INPUT', context)
   numfeatures = input_featuresource.featureCount()
   bufferdist = instance.parameterAsDouble(parameters, 'BUFFERDIST',
                                           context)
   rastercellsize = instance.parameterAsDouble(parameters, 'CELLSIZE',
                                               context)

   if feedback.isCanceled():
      return {}

   params = {
      'INPUT': parameters['INPUT'],
      'OUTPUT': parameters['BUFFER_OUTPUT'],
      'DISTANCE': bufferdist,
      'SEGMENTS': 10,
      'DISSOLVE': True,
      'END_CAP_STYLE': 0,
      'JOIN_STYLE': 0,
      'MITER_LIMIT': 10
   }
   buffer_result = processing.run(
      'native:buffer',
      params,
      is_child_algorithm=True,
      context=context,
      feedback=feedback)
   
   if feedback.isCanceled():
      return {}
   
   params = {
      'LAYER': buffer_result['OUTPUT'],
      'EXTENT': buffer_result['OUTPUT'],
      'MAP_UNITS_PER_PIXEL': rastercellsize,
      'OUTPUT': parameters['OUTPUT']
   }
   rasterized_result = processing.run(
      'qgis:rasterize',
      params,
      is_child_algorithm=True, context=context,
      feedback=feedback)
   
   if feedback.isCanceled():
      return {}
   
   results = {
      'OUTPUT': rasterized_result['OUTPUT'],
      'BUFFER_OUTPUT': buffer_result['OUTPUT'],
      'NUMBEROFFEATURES': numfeatures,
   }
   return results

```

## Convertir un modèle Processing en python

Il est possible de convertir un modèle Processing en script Python.
On peut alors le modifier avec plus de finesse.

**On ne peut pas reconvertir un script Python en modèle**.

* Depuis un modèle, cliquer sur le bouton "Convertir en script Processing".
