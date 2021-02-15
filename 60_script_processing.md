---
Title: Processing
Favicon: logo.png
Index: True
...

[TOC]

# Processing

Processing est un framework pour faire des algorithmes dans QGIS.

Toute la boite à outils Traitement dans QGIS sont des basés sur "Processing".

*Note*, depuis QGIS 3.6, il existe désormais une autre syntaxe pour 
écrire script Processing à l'aide des décorateurs Python.

## Utiliser Processing en Python avec un algorithme existant

1. Sur une couche en EPSG:2154, faire un buffer de 10 mètres par exemple.
1. Cliquer sur la petite horloge dans le panneau de Processing/Traitement en haut
1. Cliquer sur le dernier traitement en haut, puis copier/coller la ligne de Python

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

1. Partons de l'algorithme d'exemple :
   1. Panneau Traitement 
   1. `Python` en haut
   1. `Créer un nouveau script depuis un modèle
1. Modifions les fonctions une par une : 
   1. `name()`
   1. `displayName()`
   1. ...

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
# -*- coding: utf-8 -*-

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
from qgis.core import (edit,
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

## Convertir un modèle Processing en python

Il est possible de convertir un modèle Processing en script Python.
On peut alors le modifier avec plus de finesse.

**On ne peut pas reconvertir un script Python en modèle**.

1. Depuis un modèle, cliquer sur le bouton "Convertir en script Processing".
