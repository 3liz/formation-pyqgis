---
Title: Processing
Favicon: logo.png
Index: True
...

[TOC]

# Créer un script Processing

Processing est un framework pour faire des algorithmes dans QGIS.

*Note*, depuis QGIS 3.6, il existe désormais une autre syntaxe pour 
écrire script Processing à l'aide des décorateurs Python.

## Le modèle de script par défaut

* Menu `Traitement`, `Boîte à outils`. Cliquer sur le logo Python, puis sur
`Créer un nouveau script depuis un modèle.`
* Comprendre la structure.
* Utiliser Processing en ligne de commande Python pour lancer un algorithme

## Notre propre script

* Nous souhaitons pouvoir créer plusieurs tables vides assez facilement à l'aide de fichier CSV.
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

```csv
name,type,length,precision,alias
geom,polygon,2154,'',''
id,2,3,0,ID
n,10,10,0,Nom
d,2,3,0,Diamètre
l,2,3,0,Longueur
```

* Commençons par écrire le script en console : 
* Il nous faut une fonction qui liste les CSV dans un dossier.

```python
def liste_csv(folder):
    pass
```

```python
import os
import csv

def liste_csv(folder):
    csvs = []
    for root, directories, files in os.walk(folder):
        for file in files:
            if file.lower().endswith('.csv'):
                csvs.append(os.path.join(root, file))
    return csvs

folder = os.path.join(QgsProject.instance().homePath(), 'processing')
csv_files = liste_csv(folder)

for csv_file in csv_files:
    geom = 'None'
    crs = None
    fields = []
    
    with open(csv_file) as csvfile:
        reader = csv.reader(csvfile)
        for i, row in enumerate(reader):
            if i == 0:
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
            
    QgsProject.instance().addMapLayer(layer)
```

Nous allons maintenant ajouter et adapter ce code dans un script Processing :
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
    QgsField,
    QgsVectorLayer,
    edit,
    QgsProcessing,
    QgsFeatureSink,
    QgsProcessingException,
    QgsProcessingContext,
    QgsProcessingAlgorithm,
    QgsProcessingParameterFile,
    QgsProcessingParameterFeatureSource,
    QgsProcessingOutputMultipleLayers,
)
import processing


class CreateLayersFromCsvAlgorithm(QgsProcessingAlgorithm):
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
    OUTPUT_LAYERS = 'OUTPUT_LAYERS'


    def tr(self, string):
        """
        Returns a translatable string with the self.tr() function.
        """
        return QCoreApplication.translate('Processing', string)

    def createInstance(self):
        return CreateLayersFromCsvAlgorithm()

    def name(self):
        """
        Returns the algorithm name, used for identifying the algorithm. This
        string should be fixed for the algorithm, and must not be localised.
        The name should be unique within each provider. Names should contain
        lowercase alphanumeric characters only and no spaces or other
        formatting characters.
        """
        return 'createlayersfromcsv'

    def displayName(self):
        """
        Returns the translated algorithm name, which should be used for any
        user-visible display of the algorithm name.
        """
        return self.tr('Create layers from CSV')

    def group(self):
        """
        Returns the name of the group this algorithm belongs to. This string
        should be localised.
        """
        return self.tr('Formation')

    def groupId(self):
        """
        Returns the unique ID of the group this algorithm belongs to. This
        string should be fixed for the algorithm, and must not be localised.
        The group id should be unique within each provider. Group id should
        contain lowercase alphanumeric characters only and no spaces or other
        formatting characters.
        """
        return 'formation'

    def shortHelpString(self):
        """
        Returns a localised short helper string for the algorithm. This string
        should provide a basic description about what the algorithm does and the
        parameters and outputs associated with it..
        """
        return self.tr('Script pour créer des couches à partir de CSV')

    def initAlgorithm(self, config=None):
        """
        Here we define the inputs and output of the algorithm, along
        with some other properties.
        """

        # We add the input vector features source. It can have any kind of
        # geometry.
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

    def processAlgorithm(self, parameters, context, feedback):
        """
        Here is where the processing itself takes place.
        """

        # Retrieve the feature source and sink. The 'dest_id' variable is used
        # to uniquely identify the feature sink, and must be included in the
        # dictionary returned by the processAlgorithm function.
        source = self.parameterAsFile(
            parameters,
            self.INPUT,
            context
        )
        
        feedback.pushInfo('Scanning {}'.format(source))

        def liste_csv(folder):
            csvs = []
            for root, directories, files in os.walk(folder):
                for file in files:
                    if file.lower().endswith('.csv'):
                        csvs.append(os.path.join(root, file))
            return csvs

        csv_files = liste_csv(source)
        
        output_layers = []
        for csv_file in csv_files:
            feedback.pushInfo('Fichier : {}'.format(csv_file))
            geom = 'None'
            crs = None
            fields = []
            
            with open(csv_file) as csvfile:
                reader = csv.reader(csvfile)
                for i, row in enumerate(reader):
                    if i == 0:
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
                    
            output_layers.append(layer)
            
            # Ajout de la couche au projet
            context.temporaryLayerStore().addMapLayer(layer)
            context.addLayerToLoadOnCompletion(
                layer.id(),
                QgsProcessingContext.LayerDetails(
                    name,
                    context.project(),
                    self.OUTPUT_LAYERS
                )
            )
    
        return {self.OUTPUT_LAYERS: output_layers}
```
Nous avons désormais un nouveau algorithme dans la boîte à outils. Plus besoin d'ouvrir un projet avant.
