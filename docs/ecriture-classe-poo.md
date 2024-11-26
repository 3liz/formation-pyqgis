## Notion sur la POO en Python

Le framework Processing utilise le concept de la **P**rogrammation **O**rientée **O**bjet. Il existe un
[tutoriel](https://openclassrooms.com/fr/courses/4302126-decouvrez-la-programmation-orientee-objet-avec-python)
sur le site d'OpenClassRooms sur le sujet.

Mais depuis le début de la formation, nous l'utilisons sans trop le savoir. Les objets `Qgs*`, comme
`QgsVectorLayer` utilisent le principe de la POO.

On a pu créer des objets QgsVectorLayer en appelant son **constructeur** :

```python
from qgis.core import QgsVectorLayer

layer = QgsVectorLayer("C:/chemin/vers/un/fichier.gpkg|layername=communes", "communes", "ogr")
```

et ensuite, on a pu appeler des **méthodes** sur cet objet, comme :

```python
layer.setName("Communes")
layer.name()  # Retourne "Communes"
```

!!! tip
    Vous pouvez relire le passage sur la POO en début de [formation](./console.md#rappel-sur-la-poo).

### Exemple

Nous allons faire un "très" petit exemple rapide. Écrivons notre premier jeu vidéo en console ! 🎮

```python
from time import sleep

MAX_ENERGIE = 20


class Personnage:

    """ Classe représentant un personnage du jeu vidéo. """

    def __init__(self, un_nom, energie=MAX_ENERGIE):
        """ Constructeur. """
        self.nom = un_nom
        self.energie = energie

    def marcher(self):
        """ Permet au personnage de marcher.

        Cela dépense de l'énergie.
        """
        cout = 5
        if self.energie >= cout:
            print(f"{self.nom} marche.")
            self.energie -= cout
        else:
            print(f"{self.nom} ne peut pas marcher car il n'a pas assez d'énergie.")

    def courir(self):
        """ Permet au personnage de courir.

        Cela dépense de l'énergie.
        """
        cout = 10
        if self.energie >= cout:
            print(f"{self.nom} court.")
            self.energie -= cout
        else:
            print(f"{self.nom} ne peut pas courir car il n\'a pas assez d\'énergie.")

    def dormir(self):
        """ Permet au personnage de dormir et restaurer le niveau maximum d'énergie."""
        print(f"{self.nom} dort et fait le plein d'énergie.")
        for i in range(2):
            print('...')
            sleep(1)
        self.energie = MAX_ENERGIE

    def manger(self):
        """ Permet au personnage de manger et d'augmenter de 10 points le niveau d'énergie."""
        energie = 10
        print(f"{self.nom} mange et récupère {energie} points d'énergie.")
        if self.energie <= MAX_ENERGIE - energie:
            self.energie += energie
        else:
            self.energie = MAX_ENERGIE
     
    def __str__(self):
        return f"Je suis {self.nom} et j'ai {self.energie} points d'énergie"

```

### Utilisation de notre classe

`dir` est une méthode qui prend une variable en paramètre et qui indique les propriétés/méthodes de notre variable.
On peut aussi utiliser `help` qui est plus présentable.

```python    
a = Personnage('Dark Vador')
dir(a)
help(a)
```

Que remarquons-nous ?

??? "Solution"
    ```python
    a = Personnage('Dark Vador')
    a.courir()
    a.dormir()
    a.manger()
    print(a)
    ```

Afficher le nom du personnage (et juste son nom, pas la phrase de présentation)

### Ajouter d'autres méthodes

Ajoutons une méthode `dialoguer` pour discuter avec un **autre** personnage.

!!! tip Exemple de la définition de la fonction
    ```python
    def dialoguer(self, autre_personnage):
        """ Permet de dialoguer avec un autre personnage. """
        pass
    ```

1. Écrire le code la fonction à l'aide d'un `print` pour commencer disant que `X dialogue avec Y`.
2. Vérifier le niveau d'énergie, on ne peut pas parler si on est décédé !
3. Garder son code à gauche, on peut utiliser une instruction `return`

Nous pouvons désormais utiliser le constructeur afin de créer deux **instances** de notre **classe**.

```python
b = Personnage('Luke')
b.dialoguer(a)
```

??? "Solution pour la méthode `dialoguer()`"

    ```python
    def dialoguer(self, autre_personnage):
        if self.energie <= 0:
            print(f"{self.nom} ne peut pas dialoguer car il n'a pas assez d'énergie.")
            return
        
        print(f"{self.nom} dialogue avec {autre_personnage.nom} et ils échangent des informations secrètes")
    ```

Continuons notre classe pour la gestion de son inventaire. Admettons que notre personnage puisse ramasser des objets
afin de les mettre dans son sac à dos.

1. Il va falloir ajouter une nouvelle **propriété** à notre classe de type `list` que l'on peut nommer `inventaire`. Par
   défaut, son inventaire sera vide.
2. Ajoutons 3 méthodes : `ramasser`, `deposer` et `utiliser`. Pour le moment, pour faciliter l'exercice, utilisons une
   chaîne de caractère pour désigner l'objet. Ces méthodes vont interagir avec notre `inventaire` à l'aide des méthodes
   `remove()`, `append()` que l'on trouve sur une liste.
3. Pour les méthodes `deposer` et `utiliser`, nous pouvons avoir à créer une autre méthode **privée** afin de vérifier
   l'existence de l'objet dans l'inventaire. Par convention, nous préfixons la méthode par `_` comme `_est_dans_inventaire`
   afin de signaler que c'est une méthode dite **privée**. L'utilisation de cette méthode privée est uniquement à titre
   pédagogique, on peut vouloir exposer la méthode `est_dans_inventaire`. Cette méthode doit renvoyer un **booléen**.
4. Ajoutons des **commentaires** et/ou des **docstrings**, CF mémo Python. On peut utiliser la méthode `help`.
5. Pensons aussi **annotations Python**

!!! info
    Il est important de comprendre que la POO permet de construire une sorte de boîte opaque du point de vue de
    l'utilisateur de la classe. Un peu comme une voiture, elles ont toutes un capot et une pédale d'accélération.
    L'appui sur l'accélérateur déclenche plusieurs mécanismes à l'intérieur de la voiture, mais du point de vue
    utilisateur, c'est plutôt simple.

*Il y a des corrections sur les dernières méthodes [en bas de ce TP](./script-processing.md#solution)*

!!! tip
    On peut vite imaginer d'autres classes, comme `Arme`, car ramasser un bout de bois ou un sabre laser n'a pas le même
    impact lors de son utilisation dans un combat. Le dégât qu'inflige une arme sur le niveau d'énergie de l'autre
    personnage est une propriété de l'arme en question **et** du niveau du personnage.

## Solution

Sur la classe Personnage ci-dessus :

```python
def _est_dans_inventaire(self, un_objet: str) -> bool:
    return un_objet in self.inventaire

def ramasser(self, un_objet):
    print(f"{self.nom} ramasse {un_objet} et le met dans son inventaire.")
    self.inventaire.append(un_objet)

def utiliser(self, un_objet):
    if self._est_dans_inventaire(un_objet):
        print(f"{self.nom} utilise {un_objet}")
    else:
        print(f"{self.nom} ne possède pas {un_objet}")

def deposer(self, un_objet):
    if self._est_dans_inventaire(un_objet):
        print(f"{self.nom} dépose {un_objet}")
        self.inventaire.remove(un_objet)

def donner(self, autre_personnage, un_objet):
    if self._est_dans_inventaire(un_objet):
        self.inventaire.remove(un_objet)
        autre_personnage.inventaire.append(un_objet)
        print(f"{autre_personnage.nom} reçoit {un_objet} de la part de {self.nom} et le remercie 👍")
```
