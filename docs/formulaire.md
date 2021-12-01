# Formulaire

!!! warning
    Pensez à autoriser les macros dans les 
    Propriétés de QGIS ➡ Général ➡ Fichiers du projet ➡ Activer les macros

![Formulaire avec logique Python](media/formulaire_python.png)

On peut personnaliser un formulaire avec :

* un fichier QtDesigner, même si on recommande l'utilisation du mode Drag&Drop qui permet de créer des onglets
  et des catégories.
* un fichier Python afin de modifier le comportement du formulaire, ajouter des boutons, modifier la CSS etc

!!! tip
    Le blog de [Nathan](https://woostuff.wordpress.com/2011/09/05/qgis-tips-custom-feature-forms-with-python-logic/)
    est une bonne ressource concernant les formulaires et QtDesigner pour cette partie la, mais cela
    commence à être vieux.

Sur la couche [Geopackage](./solution/formulaire.gpkg), dans les propriétés de la couche ➡ Formulaire d'attributs,
cliquer sur le petit logo Python en haut bleu et jaune. Choisir l'option **Fournir le code dans cette boîte de
dialogue**.

Dans le **nom de la fonction**, mettre `my_form_open` qui correspond à l'exemple du code en dessous.

La fonction `my_form_open` sera donc exécuté par défaut lors de l'ouverture du formulaire. On remarque qu'il
y a trois paramètres qui sont donnés :

* `dialog` ➡ [QgsAttributeForm](https://qgis.org/api/classQgsAttributeForm.html) qui hérite de [QWidget](https://doc.qt.io/qt-5/qwidget.html)
* `layer` ➡ [QgsVectorLayer](https://qgis.org/api/classQgsVectorLayer.html)
* `feature` ➡ [QgsFeature](https://qgis.org/api/classQgsFeature.html)

Dans l'objet `dialog` :

* essayons de rechercher les boutons en bas **OK** et **Annuler**
* ajoutons le bouton **Aide** pour ouvrir une page internet d'aide

Pour information :

* `QWidget::findChild(NOM_CLASSE)` retourne un objet de la NOM_CLASSE spécifié dans le widget courant. Ce n'est pas une chaîne de caractère bien une classe qu'il faut donner.
* `QWidget::findChild(NOM_CLASSE, "nom_objet")`, idem que ci-dessus, mais permet de filtrer avec le nom de l'objet, très utile sur les champs.
* La barre des boutons est une `QDialogButtonBox`
* Pour ouvrir une URL : `QDesktopServices`

??? Afficher
    ```python
    from qgis.PyQt.QtCore import QUrl
    from qgis.PyQt.QtWidgets import QWidget, QDialogButtonBox
    from qgis.PyQt.QtGui import QDesktopServices
    
    def my_form_open(dialog, layer, feature):
        button_box = dialog.findChild(QDialogButtonBox)
        button_box.setStandardButtons(QDialogButtonBox.Cancel|QDialogButtonBox.Help|QDialogButtonBox.Ok)
        
        button_box.button(QDialogButtonBox.Help).clicked.connect(open_help)
    
    def open_help():
        QDesktopServices.openUrl(QUrl('https://docs.3liz.org/'))
    ```

* Appliquons une CSS sur le champ `type` pour mettre un fond rouge :

```python
type_field = dialog.findChild(QLineEdit, "type")
type_field.setStyleSheet("background-color: rgba(255, 107, 107, 150);")
```
* On souhaite rendre le champ en rouge seulement s'il y a une condition :

```python
type_field = dialog.findChild(QLineEdit, "type")
type_field.textChanged.connect(type_field_changed)

def type_field_changed():
    type_field = dialog.findChild(QLineEdit, "type")
    if type_field.text() not in ('studio', 'appartement', 'maison'):
        type_field.setStyleSheet("background-color: rgba(255, 107, 107, 150);")
        type_field.setToolTip("La valeur doit être 'studio', 'appartement' ou 'maison'.")
    else:
        type_field.setStyleSheet("")
        type_field.setToolTip()
```



* Cherchons le champ `surface` et calculons la surface avec la géométrie.

!!! info
    Notons que ce ne sont que des exemples des fonctionnalités Python. On peut faire ces masques de saisie à
    l'aide des expressions QGIS ou simplement en changeant le type de widget pour un champ en particulier.
