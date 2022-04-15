# Les actions

* Pour connaître le principe des actions dans QGIS, il faut se référer au manuel de QGIS :
    * https://docs.qgis.org/latest/fr/docs/user_manual/working_with_vector/vector_properties.html#actions-properties
* On souhaite pouvoir faire notre propre action pour inverser le sens d'une ligne, par exemple une rivière.
* Pour la couche linéaire :
  * Nous allons utiliser le script ci-dessous pour créer une couche **très** simple, mais qui permet de voir la construction
    d'une ligne en partant de zéro
  * Sinon, pour aller **beaucoup** plus vite, ajouter la couche `D_OSM_HYDROGRAPHIE/TRONCON_COURS_EAU.shp`
    mais on ne voit pas comment construire la géométrie en partant de rien.
* Faire un style rapide pour mettre en évidence le sens de la ligne à l'aide d'une `Ligne de symbole` dans
  l'onglet `Symbologie` de la couche en question.

!!! info
    La couche `D_OSM_HYDROGRAPHIE/TRONCON_COURS_EAU.shp` est de type multilinestring. Nous allons donc prendre en compte
    ce cas par défaut dans la suite de ce tutoriel.

```python
# Notation pour ajouter des attributs en créant une couche mémoire
# https://docs.qgis.org/latest/fr/docs/pyqgis_developer_cookbook/vector.html#from-an-instance-of-qgsvectorlayer
river = QgsVectorLayer('MultiLineString?crs=epsg:2154&field=id:integer&field=name:string(20)&index=yes', 'Rivers', 'memory')

QgsProject.instance().addMapLayer(river)

with edit(river):
    # Cette fonction permet de faire des vérifications sur les contraintes si nécessaires contrairement à QgsFeature(fields)
    feature = QgsVectorLayerUtils.createFeature(river)
    feature.setAttribute('id', 0)
    feature.setAttribute('name', 'Une rivière')
    geom = QgsGeometry.fromMultiPolylineXY(
    [
        [QgsPointXY(1, 1), QgsPointXY(2, 2), QgsPointXY(3, 2), QgsPointXY(4, 1)]
    ])
    feature.setGeometry(geom)
    river.addFeature(feature)

extent = river.extent()
canvas = iface.mapCanvas()
canvas.setExtent(extent)
canvas.refresh()
```
  
## Les actions par défaut

* Dans la fenêtre des propriétés d'une couche vecteur, aller dans l'onglet `Actions`.
* Cliquer sur le bouton `Créer les actions par défaut`.
* Observons quelques actions pour comprendre le fonctionnement ainsi que les **scopes/champs d'application**
  des actions.

!!! info
    Selon le champ d'application de l'action, il y a plus ou moins de **variables**.

## Notre propre action

* Commençons un nouveau par un script Python classique, laissons de côté le concept des actions pour le moment.
* Écrire une fonction qui se charge *d'inverser* une ligne. Cette fonction prend en paramètre la couche
  vecteur et une liste d'ID des entités.
* Il faut penser à vérifier le type exact de géométrie de nos lignes, dans les propriétés de la couche.

```python
def reverse_geom(layer: QgsVectorLayer, ids: list):
    """ Inverser le sens des différentes entités dans la couche layer.
    
    ids est une liste comportant les IDs des entités à inverser.
    """
    pass

```

Le mot-clé `pass` est juste une instruction Python qui ne fait **strictement** rien, mais qui permet de rendre
une ligne de code valide en respectant l'indentation. Vous pouvez la supprimer dès qu'il y a du code.

Il faut :

* Utiliser une session d'édition
* Récupérer la géométrie, tenir compte qu'il s'agit d'une multi-ligne
* Appliquer la fonction `reverse` en Python
* Utiliser `QgsVectorLayer.changeGeometry()` pour changer la géométrie d'un objet

??? "Afficher la solution"
    ```python
    def reverse_geom(layer: QgsVectorLayer, ids: list):
        """ Inverser le sens des différentes entités dans la couche layer.
        
        ids est une liste comportant les IDs des entités à inverser.
        """
        with edit(layer):
            for feature in layer.getFeatures(ids):
                geom = feature.geometry()
                lines = geom.asMultiPolyline()
                for line in lines:
                    line.reverse()
                new_geom = QgsGeometry.fromMultiPolylineXY(lines)
                layer.changeGeometry(feature.id(),new_geom)
    
    layer = iface.activeLayer()
    ids = layer.selectedFeatureIds()
    
    reverse_geom(layer, ids)
    ```

Incorporons ce code dans une action et adaptons-le légèrement :

![Inverser canalisation](./media/action_inverser_ligne.png)

```python
def reverse_geom(layer, ids):
    with edit(layer):
        for feature in layer.getFeatures(ids):
           geom = feature.geometry()
           lines = geom.asMultiPolyline()
           for line in lines:
               line.reverse() 
           new_geom = QgsGeometry.fromMultiPolylineXY(lines)
           layer.changeGeometry(feature.id(), new_geom)

layer = QgsProject.instance().mapLayer('[% @layer_id %]')
reverse_geom(layer, '[% $id %]')
```

On peut désormais cliquer sur une ligne pour automatiquement inverser une ligne.

Le code de l'action est enregistré dans le style QML de la couche vecteur. Il peut donc être partagé avec 
d'autres utilisateurs qui ne connaissent pas Python.

## Astuce pour stocker le code d'une action dans une extension QGIS

!!! tip
    Pour suivre cette partie, il faut la plupart du temps une extension par exemple, voir
    [l'autre chapitre](extension-generique.md), afin de stocker le code Python.

Pour éviter d'avoir du code les propriétés de la couche QGIS, on peut réduire le code Python
au minimum en faisant dans le cœur de l'action uniquement l'import d'une fonction et
de lancer son exécution.

Exemple du code d'une action dans l'extension QuickOSM lors de l'exécution
d'une requête rapide :

```python
from QuickOSM.core.actions import Actions
Actions.run("josm","[% "full_id" %]")
```

Ou alors l'extension RAEPA :

```python
from qgis.utils import plugins
plugins['raepa'].run_action("nom_de_laction", params)
```

## Avec Processing

Dans le chapitre Processing, nous verrons comment intégrer un
[algorithme Processing](script-processing.md#utiliser-un-script-processing-dans-une-action) dans une action.
