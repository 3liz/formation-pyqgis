# Processing

Processing est un framework pour faire des algorithmes dans QGIS.

Toute la boite à outils Traitement dans QGIS sont des basés sur "Processing".

*Note*, depuis QGIS 3.6, il existe désormais une autre syntaxe pour 
écrire script Processing à l'aide des décorateurs Python.
Lire sur [Docteur Python pour les décorateurs](https://python.doctor/page-decorateurs-decorator-python-cours-debutants)

## Documentation

Pour l'écriture d'un script Processing, tant en utilisant la **POO** ou la version avec les décorateurs, il y a
une page sur la 
[documentation](https://docs.qgis.org/latest/fr/docs/user_manual/processing/scripts.html#writing-new-processing-algorithms-as-python-scripts).

## Utiliser Processing en Python avec un algorithme existant

* Sur une couche en EPSG:2154, faire un buffer de 10 mètres par exemple.
* Cliquer sur la petite horloge dans le panneau de Processing/Traitement en haut
* Cliquer sur le dernier traitement en haut, puis copier/coller la ligne de Python

On peut appeler un traitement en ligne de commande Python :

```python
result = processing.run(
    "native:buffer", 
    {
        'INPUT': '/chemin/vers/HYDROGRAPHIE/CANALISATION_EAU.shp',
        'DISTANCE': 10,
        'SEGMENTS': 5,
        'END_CAP_STYLE': 0,
        'JOIN_STYLE': 0,
        'MITER_LIMIT': 2,
        'DISSOLVE': False,
        'OUTPUT': 'TEMPORARY_OUTPUT',
    }
)
# print(result)
```

!!! tip
    Pour obtenir l'identifiant de l'algorithme, laissez la souris sur le nom de
    l'algorithme pour avoir son info-bulle dans le panneau traitement.

Lien vers la documentation : https://docs.qgis.org/latest/fr/docs/user_manual/processing/console.html

```python
QgsProject.instance().addMapLayer(result['OUTPUT'])
```

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
            'INPUT':'/chemin/vers/HYDROGRAPHIE/BARRAGE.shp',
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

!!! warning
    Attention si utilisation de `iface.activeLayer()` qui va être modifié si utilisation de `QgsProject.instance().addMapLayer()`.
    Il peut être nécessaire d'extraire la sélection de la couche hors de la boucle.

## Lancer l'interface graphique de notre algorithme

Au lieu de `processing.run`, on peut créer **uniquement** le dialogue. Il faut alors l'afficher manuellement.

```python
dialog = processing.createAlgorithmDialog(
    "native:buffer",
    {
        'INPUT': '/data/lines.shp',
        'DISTANCE': 100.0,
        'SEGMENTS': 10,
        'DISSOLVE': True,
        'END_CAP_STYLE': 0,
        'JOIN_STYLE': 0,
        'MITER_LIMIT': 10,
        'OUTPUT': '/data/buffers.shp'
    }
)
dialog.show()
```

Ou alors directement lancer exécution du dialogue :

```python
processing.execAlgorithmDialog(
    "native:buffer",
    {
        'INPUT': '/data/lines.shp',
        'DISTANCE': 100.0,
        'SEGMENTS': 10,
        'DISSOLVE': True,
        'END_CAP_STYLE': 0,
        'JOIN_STYLE': 0,
        'MITER_LIMIT': 10,
        'OUTPUT': '/data/buffers.shp'
    }
)
```

## Convertir un modèle Processing en python

Il est possible de convertir un modèle Processing en script Python.
On peut alors le modifier avec plus de finesse.

**On ne peut pas reconvertir un script Python en modèle**.

* Depuis un modèle, cliquer sur le bouton "Convertir en script Processing".


## Utiliser un script Processing dans une action

On peut utiliser `processing.run()` dans le code d'une action, pour faire une zone tampon sur un point en particulier
par exemple.

On peut lancer, graphiquement depuis la boîte à outil Processing, une zone tampon, **avec** une **sélection**.
Regardons ensuite dans l'historique Processing pour voir comment QGIS a pu spécifier la sélection dans son appel PyQGIS.

On note l'usage d'une nouvelle classe `QgsProcessingFeatureSourceDefinition`.

On souhaite donc pouvoir faire une zone tampon personnalisée en cliquant sur un point à l'aide d'une action.

Il faut donc revoir le code dans le chapitre [actions](./action.md) pour voir comment créer une action.
Pour utiliser la sélection, nous allons faire dans l'action :

```python
from qgis.core import QgsProject, QgsVectorLayer

layer: QgsVectorLayer = QgsProject.instance().mapLayer('[% @layer_id %]')
layer.selectByIds([int('[% $id %]')])
# Ajouter ici le code processing.run avec une sélection
layer.removeSelection()
```

On peut compléter l'action avec un `processing.run` en utilisant uniquement l'entité en sélection.

??? "Solution"
    ```python
    import processing

    layer = QgsProject.instance().mapLayer('[% @layer_id %]')
    layer.selectByIds([int('[% $id %]')])

    result = processing.run(
        "native:buffer",
        {
            'INPUT':QgsProcessingFeatureSourceDefinition(layer.source(), selectedFeaturesOnly=True),
            'DISTANCE':1000,
            'SEGMENTS':5,
            'END_CAP_STYLE':0,
            'JOIN_STYLE':0,
            'MITER_LIMIT':2,
            'DISSOLVE':False,
            'OUTPUT':'TEMPORARY_OUTPUT'
        }
    )
    QgsProject.instance().addMapLayer(result['OUTPUT'])

    layer.removeSelection()
    ```

## Introduction aux décorateurs

Comme mentionné au début de ce chapitre, il est possible de ne pas utiliser la [POO](./ecriture-classe-poo.md) pour
écrire un "Script Processing" mais plutôt l'écriture à l'aide des **décorateurs**.

Dans la documentation QGIS, on trouve :

* le [tableau de correspondance](https://docs.qgis.org/3.34/fr/docs/user_manual/processing/parameters.html#processing-algs-input-output)
  entre la notation dans le décorateur et pour les types des paramètres
* un [exemple avec décorateur](https://docs.qgis.org/3.34/fr/docs/user_manual/processing/scripts.html#the-alg-decorator)
[la correspondance](https://docs.qgis.org/latest/fr/docs/user_manual/processing/scripts.html#input-types)

Le code suivant utilise le décorateur `@alg` :

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
