# Expression

On peut définir sa propre expression QGIS à l'aide de Python.
Il existe un chapitre dans le 
[Python cookbook](https://docs.qgis.org/latest/fr/docs/user_manual/expressions/expression.html?#function-editor)

Dans la fenêtre des expressions QGIS, on peut observer la fonction déjà existante.

`feature`, `parent` et `context` sont des paramètres particuliers dans la **signature** de la fonction. Si QGIS trouve
le mot-clé, il assigne l'objet correspondant :

* `feature` : [QgsFeature](https://api.qgis.org/api/classQgsFeature.html) pour l'entité en cours
* `parent` : [QgsExpression](https://api.qgis.org/api/classQgsExpression.html) l'expression QGIS en cours
* `context` : [QgsExpressionContext](https://api.qgis.org/api/classQgsExpressionContext.html) pour le contexte d'exécution
  de l'expression

## Exemple

On souhaite utiliser l'API de Wikipédia afin de récupérer la **description** d'un terme.

![API Wikipédia dans QGIS](media/editeur_expression_wikipedia.png)

Par exemple, si on cherche le terme `Montpellier` avec l'API Wikipédia :

https://fr.wikipedia.org/w/api.php?action=query&titles=Montpellier&prop=description&format=json

Il existe plusieurs moyens de faire des requêtes HTTP en Python et/ou PyQGIS. Utilisons la technique Processing
avec l'algorithme "Téléchargeur de fichier" (graphiquement, il n'est disponible que dans le modeleur) :

```python
search = "montpellier"
results = processing.run(
    "native:filedownloader",
    {
        "URL": f"https://fr.wikipedia.org/w/api.php?action=query&titles={search}&prop=description&format=json",
        "OUTPUT": "TEMPORARY_OUTPUT"
    }
)
```

!!! tip
    On peut afficher le panneau de débogage et développement de QGIS afin de voir les requêtes HTTP.
    Il se trouve dans le menu **Vue** ▶ **Panneau**  ▶ **Débogage et développement**

On va désormais **parser** le fichier JSON que l'on obtient avec la libraire `json` afin de récupérer la `description` :

```python
import json

with open("/mon/fichier.json") as f:
    data = json.load(f)

pages = data['query']['pages']
key = list(pages.keys())[0]
description = pages[key]['description']
print("description")
```

??? "Solution complète pour l'expression QGIS"
    ```python
    import json
    import processing
    
    @qgsfunction(args='auto', group='Formation PyQGIS')
    def wiki_description(search, feature, parent):
        """Permet de récupérer la description Wikipedia
        
        wiki_description('Paris') ➡ 'capitale de la France'
        """
        results = processing.run(
            "native:filedownloader",
            {
                "URL": f"https://fr.wikipedia.org/w/api.php?action=query&titles={search}&prop=description&format=json",
                "OUTPUT": "TEMPORARY_OUTPUT"
            }
        )
    
        with open(results['OUTPUT']) as f:
            data = json.load(f)
    
        pages = data['query']['pages']
        key = list(pages.keys())[0]
        description = pages[key]['description']
        return description
    ```
