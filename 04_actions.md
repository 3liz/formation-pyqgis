# Les actions

* Pour connaître les actions dasn QGIS, il faut se référer au manuel de QGIS :
    * https://docs.qgis.org/3.4/fr/docs/user_manual/working_with_vector/vector_properties.html#actions-properties
    
## Manipulation

* Ajouter la couche `canalisation`.
* Écrire une fonction qui se charge *d'inverser* une ligne. Cette fonction prend en paramètre la couche vecteur et une liste d'ID.

```python
def reverse_geom(layer, ids):
    with edit(layer):
        for feature in layer.getFeatures(ids):
           geom = feature.geometry()
           lines = geom.asMultiPolyline()
           for line in lines:
               line.reverse() 
           newgeom = QgsGeometry.fromMultiPolylineXY(lines)
           layer.changeGeometry(feature.id(),newgeom)

layer = iface.activeLayer()
ids = layer.selectedFeatureIds()

reverse_geom(layer, ids)
```

Incorporons ce code dans une action et adaptons le un peu:

![Inverser canalisation](./media/action_inverser_ligne.png)

```python
def reverse_geom(layer, ids):
    with edit(layer):
        for feature in layer.getFeatures(ids):
           geom = feature.geometry()
           lines = geom.asMultiPolyline()
           for line in lines:
               line.reverse() 
           newgeom = QgsGeometry.fromMultiPolylineXY(lines)
           layer.changeGeometry(feature.id(),newgeom)

layer = QgsProject.instance().mapLayer('[% @layer_id %]')
reverse_geom(layer, '[% $id%]')
```