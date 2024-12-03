# Symbologie

Étant donné que la symbologie pouvant être complexe dans QGIS Bureautique, avec les différents types de symbologie,
les différents niveaux de symbole, les ensembles de règles avec des filtres etc, il n'est pas forcément simple de
s'y retrouver dans l'API PyQGIS également.

## Utilisation d'un QML au lieu de PyQGIS

On peut se passer de PyQGIS pour fournir une symbologie à l'aide d'un fichier **QML**, si on ne souhaite pas faire ça en
Python entièrement.

Regarder les méthodes `loadNamedStyle` de la classe `QgsMapLayer`.

```python
from pathlib import Path

layer = iface.activeLayer()

qml = Path("path_to_qml")
if qml.exists():
    layer.loadNamedStyle(str(qml))
    iface.legendInterface().refreshLayerSymbology(layer)
```

## Classes utiles en PyQGIS

Voir les graphiques d'héritage sur :

* [QgsFeatureRenderer](https://api.qgis.org/api/classQgsFeatureRenderer.html) pour le moteur de rendu.
* [QgsSymbol](https://api.qgis.org/api/classQgsSymbol.html) pour un symbole, selon le type de géométrie.

## Afficher les infos de la symbologie

* Affichage sous forme textuelle

```python
layer = iface.activeLayer()
renderer = layer.renderer()
print(renderer.dump())
```

> SINGLE: FILL SYMBOL (1 layers) color 125,139,143,255

* Affichage du "dictionnaire" contenant l'ensemble des informations pour un niveau de symbole :

```python
layer = iface.activeLayer()
renderer = layer.renderer()
print(renderer.symbol().symbolLayers()[0].properties())
```

> {'border_width_map_unit_scale': '3x:0,0,0,0,0,0', 'color': '125,139,143,255', 'joinstyle': 'bevel', 'offset': '0,0', 'offset_map_unit_scale': '3x:0,0,0,0,0,0', 'offset_unit': 'MM', 'outline_color': '35,35,35,255', 'outline_style': 'solid', 'outline_width': '0.26', 'outline_width_unit': 'MM', 'style': 'solid'}

## Affecter une symbologie à une couche

**Il peut être très pratique de partir d'une symbologie existante, faite via l'interface graphique, puis de l'exporter pour voir les propriétés.**

### Un symbole ponctuel unique simple

```python
from qgis.core import QgsMarkerSymbol, QgsSingleSymbolRenderer

symbol = QgsMarkerSymbol.createSimple(
    {
        "name": "circle",
        "color": "yellow",
        "size": 3,
    }
)
renderer = QgsSingleSymbolRenderer(symbol)
layer = iface.activeLayer()
layer.setRenderer(renderer)
# layer.triggerRepaint()  # If necessary
```

### Un symbole linéaire unique sous forme de flèche

```python
from qgis.core import QgsApplication, QgsSymbol, Qgis, QgsSingleSymbolRenderer
from qgis.PyQt.QtGui import QColor

# Quelques propriétés d'une flèche si besoin de surcharger. Utiliser le code PyQGIS pour récupérer la liste des propriétés.
ARROW = {
    'arrow_start_width': '1',
    'arrow_start_width_unit': 'MM',
    'arrow_start_width_unit_scale': '3x:0,0,0,0,0,0',
    'arrow_type': '0',
}

registry = QgsApplication.symbolLayerRegistry()
line_metadata = registry.symbolLayerMetadata('ArrowLine')
line_layer = line_metadata.createSymbolLayer(ARROW)
line_layer.setColor(QColor('#33a02c'))

symbol = QgsSymbol.defaultSymbol(Qgis.GeometryType.LineGeometry)
symbol.deleteSymbolLayer(0)
symbol.appendSymbolLayer(line_layer)


renderer = QgsSingleSymbolRenderer(symbol)
layer = iface.activeLayer()
layer.setRenderer(renderer)
```
