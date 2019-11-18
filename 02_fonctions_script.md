# Écriture de fonction Python

La console c'est bien, mais très limitant. Passons à l'écriture d'un script qui va nous faciliter l'organisation du code en passant par l'ajout de fonction.

Voici le dernier script du fichier précédent, mais avec la gestion des erreurs:
* Redémarrer QGIS
* N'ouvrer pas le projet précédent
* Ouvrer la console, puis cliquer sur `Afficher l'éditeur`
* Copier/coller le script ci-dessous
* Exécuter le

```python
from os.path import join, isfile, isdir
dossier = '201909_11_ILE_DE_FRANCE_SHP_L93_3857'
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
* Corriger les erreurs ;-)
* À l'aide du mémo Python:
	* Essayons de faire une fonction qui prend 2 paramètres
		* la thématique
		* le nom du shapefile
	* La fonction se chargera de faire le nécessaire, par exemple: `charger_couche('H_OSM_ADMINISTRATIF', 'COMMUNE')`
* Une des solutions:


```
from os.path import join, isfile, isdir

def charger_couche(thematique, shapefile):
    """Fonction qui charge une couche shapefile dans une thématique."""
    dossier = '201909_11_ILE_DE_FRANCE_SHP_L93_2154'

    racine = QgsProject.instance().homePath()
    if not racine:
        iface.messageBar().pushMessage('Erreur de chargement','Le projet n\'est pas enregistré', Qgis.Critical)
        return False
        
    fichier_shape = join(racine, dossier, thematique, '{}.shp'.format(shapefile))
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

* Essayons de faire une fonction qui liste les shapefiles d'une certaine thématique. `os.walk(path)` permet de parcourir un chemin.

```python
def liste_shapefiles(thematique):
    """Liste les shapefiles d'une thématique."""
    dossier = '201909_11_ILE_DE_FRANCE_SHP_L93_2154'
    racine = QgsProject.instance().homePath()
    shapes = []
    for root, directories, files in os.walk(join(racine, dossier, thematique)):
        for file in files:
            if file.lower().endswith('.shp'):
                shapes.append(file.replace('.shp', ''))
    return shapes

shapes = liste_shapefiles('H_OSM_ADMINISTRATIF')
print(shapes)
```
