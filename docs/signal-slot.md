# Les signaux et les slots

## Définition

Nous avons pu voir dans la documentation des librairies **Qt** et **QGIS**, il y a une section **Signals**.

Chaque **objet** émet très souvent un **signal** dès qu'une action est faite sur l'objet. Cela sert à déclencher du code
Python lorsqu'un signal précis est émis.

Par exemple sur la documentation de [QgsMapLayer](https://qgis.org/pyqgis/3.34/core/QgsMapLayer.html), on peut chercher
le tableau `signals`.

!!! info
    Comme on peut le voir dans la [documentation CPP](https://api.qgis.org/api/classQgsMapLayer.html#a30359eca2431a62016cc30d390d811bb),
    c'est désormais dans la classe `QgsMapLayer` et non `QgsVectorLayer` depuis QGIS 3.22. 🧐

La plupart des signaux sont aux **passés**, par exemple `crsChanged`, `nameChanged`. Cependant, certaines sont dans un
"futur" proche comme `willBeDeleted`.

## Syntaxe

On dit que l'on souhaite **connecter** un signal à une fonction/slot :

```python
variable_de_lobjet.nom_du_signal.connect(nom_de_la_fonction)
```

!!! danger
    Il ne faut pas écrire `nom_de_la_fonction()` car on ne souhaite pas **appeler** la fonction, juste **connecter**.

Cela sera Python, **plus tard**, quand le signal sera émis, que la fonction sera réellement appelée.

## Exemple

Par exemple, dans la classe `QgsMapLayer`, cherchons un signal qui est émis **après** (before) que la session d'édition
commence. Il s'agit de `editingStarted`.

Affichons un message à l'utilisateur lors du début et de la fin d'une session d'édition.

!!! tip
    On profite de cet exemple pour voir comment évaluer une expression QGIS à l'aide des différents contextes.

```python
def user_from_qgis() -> str:
    """ À l'aide d'une expression QGIS, récupération du nom d'utilisateur."""
    context = QgsExpressionContext()
    context.appendScope(QgsExpressionContextUtils.globalScope())
    # On peut théoriquement s'arrêter à ce niveau la concernant l'ajout des "scopes" avec le GlobalScope
    # Mais on peut ajouter d'autre "scope", comme ajouter celui du projet :
    # context.appendScope(QgsExpressionContextUtils.projectScope(project))
    # context.appendScope(QgsExpressionContextUtils.layerScope(layer))

    # On peut ensuite évaluer l'expression QGIS
    # "@user_account_name" ou encore "@user_full_name"
    expression = QgsExpression("@user_full_name")
    return expression.evaluate(context)

def user_from_os() -> str:
    """ À l'aide de l'OS, retourne le nom d'utilisateur."""
    import os
    return os.getlogin()

def we_are_watching_you():
    """ Just warn the user about the editing session."""
    current_user = user_from_qgis()
    # Attention aux effets si on lance le code plusieurs fois !
    # print("Hello 😉")
    iface.messageBar().pushMessage('Hey',f'Be careful <strong>{current_user}</strong> while you are editing 🧐', Qgis.Warning)

def thanks():
    iface.messageBar().pushMessage('Hey', "Thanks 😉", Qgis.Success)


layer = iface.activeLayer()

layer.beforeEditingStarted.connect(we_are_watching_you)
layer.editingStopped.connect(thanks)
```
