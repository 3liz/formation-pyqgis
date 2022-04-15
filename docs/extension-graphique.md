# Créer une extension QGIS avec une interface graphique

Pour faire ce chapitre, il faut d'abord avoir une extension de base, à l'aide du chapitre précédent.

## QtDesigner

Créons un fichier QtDesigner comme-ceci : 

![QtDesigner](media/qt_designer_0.png)

et y ajouter des "widgets" :

![QtDesigner](media/qt_designer_1.jpg)

### Astuces

* Ouvrir la page des "slots/signaux" depuis la barre d'outils et supprimer ceux qui existent.

* Faire un clic droit sur "QDialog" à droite et faire une mise en page "vertical".

!!! tip
    Ne pas changer la propriété `objectName` pour le moment.

On peut [télécharger](./solution/dialog.ui) la solution si besoin.

## La classe qui accompagne

Créons un fichier `dialog.py` avec le contenu suivant :

```python

from qgis.core import Qgis
from qgis.utils import iface
from qgis.PyQt.QtWidgets import QDialog, QDialogButtonBox
from qgis.PyQt import uic
from pathlib import Path

folder = Path(__file__).resolve().parent
ui_file = folder / 'dialog.ui'
ui_class, _ = uic.loadUiType(ui_file)


class MonDialog(ui_class, QDialog):

    def __init__(self):
        super().__init__()
        self.setupUi(self)  # Fichier de QtDesigner

```

Modifions la méthode la méthode `run` du fichier `__init__.py` en 

```python
    def run(self):
        from .dialog import MonDialog
        dialog = MonDialog()
        dialog.exec_()
```

Relançons l'extension à l'aide du "plugin reloader" et cliquons sur le bouton.

## Les signaux et les slots

Connectons le signal `clicked` du bouton "Annuler" dans le constructeur `__init__` : 

```python
self.buttonBox.button(QDialogButtonBox.Cancel).clicked.connect(self.close)
```

On dit que `clicked` est un **signal**, auquel on connecte le **slot** `close`. 

Connectons-le **signal** `clicked` du bouton "Accepter" à notre propre **slot** (qui est une fonction) :

```python
self.buttonBox.button(QDialogButtonBox.Ok).clicked.connect(self.click_ok)
```

et ajoutons notre propre fonction `click_ok` pour quitter la fenêtre et en affichant la saisie de
l'utilisateur dans la QgsMessageBar de QGIS.

Le widget de saisie est un QLineEdit : https://doc.qt.io/qt-5/qlineedit.html

```python
def click_ok(self):
    message = self.lineEdit.text()
    iface.messageBar().pushMessage('Notre plugin', message, Qgis.Success)
```

Faire le test dans QGIS avec une saisie de l'utilisateur et fermer la fenêtre.

Continuons en rendant en lecture seule le gros bloc de texte et affichons à l'intérieur la description de la
la couche qui est sélectionnée dans le menu déroulant.

Documentation :

* QPlainTextEdit : https://doc.qt.io/qt-5/qplaintextedit.html
* QgsMapLayerComboBox : https://qgis.org/api/classQgsMapLayerComboBox.html

Dans le `__init__` :

```python
self.plainTextEdit.setReadOnly(True)
self.mMapLayerComboBox.layerChanged.connect(self.layer_changed)
```

Et la nouvelle fonction qui va se charger de mettre à jour le texte :

```python

def layer_changed(self):
    self.plainTextEdit.clear()
    layer = self.mMapLayerComboBox.currentLayer()
    if layer:
        self.plainTextEdit.appendPlainText(f"{layer.name()} : {layer.crs().authid()}")
    else:
        self.plainTextEdit.appendPlainText("Pas de couche")

```

On peut donc désormais cumuler l'ensemble des chapitres précédents pour lancer des algorithmes, manipuler les
données, etc.

!!! tip "Bonus"
    Ajouter un nouveau bouton pour ouvrir une fenêtre d'un dialogue Processing 🚀

## Solution

??? Afficher
    ```python
    
    from qgis.core import Qgis
    from qgis.utils import iface
    from qgis.PyQt.QtWidgets import QDialog, QDialogButtonBox
    from qgis.PyQt import uic
    from pathlib import Path
    
    folder = Path(__file__).resolve().parent
    ui_file = folder / 'dialog.ui'
    ui_class, _ = uic.loadUiType(ui_file)
    
    
    class MonDialog(ui_class, QDialog):
    
        def __init__(self, parent=None):
            _ = parent
            super().__init__()
            self.setupUi(self)  # Fichier de QtDesigner
    
            # Connectons les signaux
            self.buttonBox.button(QDialogButtonBox.Ok).clicked.connect(self.click_ok)
            self.buttonBox.button(QDialogButtonBox.Cancel).clicked.connect(self.close)
    
            self.plainTextEdit.setReadOnly(True)
            self.mMapLayerComboBox.layerChanged.connect(self.layer_changed)
    
        def click_ok(self):
            self.close()
            message = self.lineEdit.text()
            iface.messageBar().pushMessage('Notre plugin', message, Qgis.Success)
    
        def layer_changed(self):
            self.plainTextEdit.clear()
            layer = self.mMapLayerComboBox.currentLayer()
            if layer:
                self.plainTextEdit.appendPlainText(f"{layer.name()} : {layer.crs().authid()}")
            else:
                self.plainTextEdit.appendPlainText("Pas de couche")
    
    ```

## Organisation du code

Il ne faut pas hésiter à créer des fichiers afin de séparer le code.

On peut aussi créer des dossiers afin d'y mettre plusieurs fichiers Pythons. Un dossier en Python se nomme un
**module**. Pour faire un module compatible, il faut ajouter un fichier `__init__.py` même s’il n'y a rien
dedans.

!!! warning
    Il ne faut vraiment pas oublier le fichier `__init__.py`. Cela peut empêcher Python de fonctionner
    correctement. Un bon [IDE](./ide-git.md#utilisation-dun-ide) peut signaler ce genre d'erreur.

Dans l'exemple ci-dessus, on peut diviser le code du fichier `__init__.py` :

```python
def classFactory(iface):
    from minimal.plugin import MinimalPlugin
    return MinimalPlugin(iface)
```

En faisant un couper/coller, enlever la classe `MinimalPlugin` du fichier `__init__.py`.

!!! tip
    On essaie souvent d'avoir une classe par fichier en Python.

Créer un fichier `plugin.py` et ajouter le contenu en collant. Il est bien de vérifier les imports dans les
deux fichiers.

## Un dossier resources

On peut créer un fichier `qgis_plugin_tools.py` afin d'y ajouter des **outils** :

```python
"""Tools to work with resource files."""

"""Tools to work with resources files."""

from pathlib import Path


def plugin_path(*args) -> Path:
    """Return the path to the plugin root folder."""
    path = Path(__file__).resolve().parent
    for item in args:
        path = path.joinpath(item)

    return path


def resources_path(*args) -> Path:
    """Return the path to the plugin resources folder."""
    return plugin_path("resources", *args)

# On peut ajouter ici une méthode qui charge un fichier UI qui se trouve dans le dossier "UI"
# et retourne la classe directement
```

On peut ensuite créer un dossier `resources` puis `icons` afin d'y déplacer un fichier PNG, JPG, SVG.

!!! warning
    Attention à la taille de vos fichiers pour un petit icône

Dans une extension graphique pour les icônes :

```python
self.action = QAction(
    QIcon(resources_path('icons', 'icon.svg')),
    'Go!',
    self.iface.mainWindow())
```

Dans une extension Processing, dans le **provider** et les **algorithmes** :

```python
def icon(self):
    return QIcon(str(resources_path("icons", "icon.png")))

```