# Introduction au language Python

## Qu'est-ce que Python ?

* Multi-usage (WEB, application graphique, script, serveur etc)
* Programmation Orientée Objet (POO)
	* Tout est objet
* Interprété
* Centré sur la lecture et la productivité
	* Syntaxe du code simple
* Grosse communauté
	* De nombreux packages disponibles sur internet sur [PyPi.org](https://pypi.org/)

Exemple d'un code qui déclare une variable et compare si sa valeur est supérieur à 5 afin d'afficher un message :

```python
# Déclaration d'une variable de type entier
x = 10

# Déclaration d'une variable chaîne de caractère
info = 'X est supérieur à 5'

if x > 5:
	print(info)
```

## Versions

* Python 2
	* Sortie en 2000
	* **Il a été très** utilisé, notamment sur les tutoriels sur internet et quelques projets qui tardent à
	 se mettre à jour
	* Une adoption massive (QGIS 2)
	* Dernière version le 1 janvier 2020
* Python 3
    * Sortie en 2008, mais il s'agit d'une adoption très lente, tellement Python 2 a été massivement adopté.
    * Dernière version 3.13.X du 7 octobre 2024
    * 1 version majeure par an, en octobre
    * QGIS 3 requiert :
        * Python 3.5 minimum for QGIS 3.4
        * Python 3.6 minimum for QGIS 3.18
        * Python 3.7 minimum for QGIS 3.20
        * Python 3.9 minimum for QGIS 3.40
	* Version de Python souvent supérieure à la version minimum, sauf sur MacOS… 😑
    * [Python release cycle](https://devguide.python.org/versions/#versions)

## Rappel de base sur Python

* Un mémo Python plus important sur [W3Schools](https://www.w3schools.com/python/)
* [Docteur Python](https://python.doctor/) et son mémo
* Un cours Python sur [OpenClassRooms](https://openclassrooms.com/fr/courses/4262331-demarrez-votre-projet-avec-python)

## La console

Pour la suite de la formation, nous allons utiliser la console Python de QGIS.

Dans le menu Extensions ➡ Console Python.

!!! tip
	Souvent, avec Windows, il y a un conflit avec un raccourci clavier pour taper le caractère `{` ou `}`
	dans la console.

	Ces caractères sont utilisés en Python. Il est donc conseillé de supprimer ce raccourci clavier.
	Il s'agit du "zoom + secondaire" dans QGIS → menu Préférences ➡ Raccourcis clavier.


## Les types de données

Une variable peut contenir un entier, un booléen (`True` ou `False`), chaîne de caractères, nombre décimal, un
objet...
Il y a un faible typage des variables, c'est-à-dire qu'une variable peut changer de type au cours de l'exécution
du programme.

```python
# Pour créer une variable, on déclare juste le nom de la variable ainsi que sa valeur :
compteur = 0
```

Nous allons par la suite utiliser `type(variable)` pour vérifier le **type** de la variable.

```python
mon_compteur = 0
type(mon_compteur)
<class 'int'>

est_valide = False
type(est_valide)
<class 'bool'>

nom_couche = 'communes'
type(nom_couche)
<class 'str'>

nom_couche = "communes"
type(nom_couche)
<class 'str'>

texte = 'Bonjour je m\'appelle "Olivier"'
type(texte)
<class 'str'>

densite = 3.5
type(densite)
<class 'float'>

nom_couche = None
type(nom_couche)
<class 'NoneType'>

```

## Les structures de données

Il existe quatre types de structure de données :

* les variables simples (ci-dessus)

* les listes (modifiables)

!!! tip
	[Documentation Python sur les listes](https://docs.python.org/3/tutorial/datastructures.html#more-on-lists)

```python
# Créer une liste vide
nombres = []
type(nombres)
<class 'list'>

# Créer une liste avec des éléments à l'intérieur
mois = ['janvier', 'février', 'mars']

# Ajouter un élément
mois.append('avril')
# Ajouter une autre liste
mois.extend(['mai', 'juin'])

# Nombre de mois
len(mois)

# Supprimer un élément
del mois[1]

# On peut accéder à un élément avec un "index" à l'aide de []
mois[2]

# Attention à l'index maximum
mois[12]
Traceback (most recent call last):
  File "/usr/lib/python3.12/code.py", line 90, in runcode
    exec(code, self.locals)
  File "<input>", line 1, in <module>
IndexError: tuple index out of range
```

* les tuples, comme des listes, mais non modifiables

!!! tip
	[Documentation Python sur les tuples](https://docs.python.org/3/tutorial/datastructures.html#more-on-lists)

```python
liste = ('route double sens', 'route sens unique')
type(liste)
<class 'tuple'>
len(liste)
2
liste[0]

liste[5]
Traceback (most recent call last):
  File "/usr/lib/python3.12/code.py", line 90, in runcode
    exec(code, self.locals)
  File "<input>", line 1, in <module>
IndexError: tuple index out of range

```

* les dictionnaires

*Attention*, les dictionnaires ne sont pas ordonnés, de façon native, même depuis Python 3.9.
Si vraiment, il y a besoin, il existe une classe [OrderedDict](https://docs.python.org/3/library/collections.html),
mais ce n'est pas une structure de données native dans Python.
C'est un objet qu'il faut importer.

```python
commune = {}
type(commune)
# <class 'dict'>
commune['nom'] = 'Besançon'
commune['code_insee'] = 25056
commune['est_prefecture'] = True

# Ou directement lors de la création de la variable :
commune = {'nom': 'Besançon', 'code_insee': 25056, 'est_prefecture': True}
```

## Les commentaires

Pour commenter le code dans un script, pas dans la console : 

```python
# Ceci est un commentaire sur une ligne

""" Ces lignes sont réservés pour la documentation de l'API et ne doivent pas être des lignes de commentaires. """

```

## Arithmétique

```python
a = 10
# Opérateurs de base
b = a + 1
c = a - 1
d = a * 2
e = a / 2

# Les espaces ne sont pas importants
# 1+2 ou 1 + 2 sont équivalents

# Il est souvent utile de faire de l'incrémentation ou décrémentation d'une variable :
a = a + 1
# mais on écrit plus souvent
a += 1
# On peut changer le pas d'incrémentation ou alors faire de la décrémentation
a -= 1 # Diminuer de 1
a += 5 # Incrémenter de 5


a = 10
f = a % 3  # Fonction "modulo", résultat 1
g = a ** 2  # Fonction puissance, résultat 100
```

## Concaténer des chaînes et des variables

Concaténer, c'est assembler des chaînes de caractères dans une seule et même sortie.
On peut concaténer des variables entre elles ou du texte.

Il existe plein de manières de faire, mais certaines sont plus pratiques que d'autres
```python
# Non recommandé
a = 'bon'
b = 'jour'
a + b  # 'bonjour'
c = 1
a + c  # Erreur
a + str(c)  # Marche
```

À l'ancienne avec `%`
```python
prenom = 'Pierre'
numero_jour = 2
bienvenue = 'Bonjour %s !' % prenom
bienvenue = 'Bonjour %s, nous sommes le %s novembre' % (prenom, numero_jour)
```

Nouveau avec `{}` et `format`
```python
prenom = 'Pierre'
numero_jour = 2
bienvenue = 'Bonjour {} !'.format(prenom)
bienvenue = 'Bonjour {}, nous sommes le {} novembre'.format(prenom, numero_jour)
bienvenue = 'Bonjour {prenom}, nous sommes le {jour} novembre'.format(prenom=prenom, jour=numero_jour)
```

!!! warning
    Attention à la **portée des variables**.

Encore plus moderne avec `fstring`
```python
prenom = 'Pierre'
numero_jour = 2
bienvenue = f'Bonjour {prenom} !'
bienvenue = f'Bonjour {prenom}, nous sommes le {numero_jour} novembre'
```

## Opérateurs logiques

```python
a > b
a >= b
a < b
a <= b
a == b
a != b

# Dans plusieurs langages, pour vérifier si "a" est entre deux bornes :
0 < a and a < 10
# En Python, on peut faire
0 < a < 10

# Pour les objets
a is b
a is not b
a in b
```

## Condition

**Important**, Python oblige l'indentation sinon il y a une erreur. Par convention, il s'agit de 4 espaces. 


```python
note = 13
if note >= 16:
    if note == 20:
        print('Toutes mes félicitations')
    else:
        print('Félicitations')
elif 14 <= note < 16:
    print('Très bien')
elif 12 <= note < 14:
    print('Bien')
else:
    print('Peu mieux faire')
```

## Boucle for

Utile lors que l'on connait le nombre de répétitions avant l'exécution de la boucle.

```python
countries = ['Allemagne', 'Espagne', 'France']
for country in countries:
    print(f'Pays : {country}')

for x in range(10):
    print(x)

regions = {
    'Auvergne-Rhône-Alpes': 'Lyon',
    'Bourgogne-Franche-Comté': 'Dijon',
    'Bretagne': 'Rennes',
    'Centre-Val de Loire': 'Orléans',
}

for region in regions:
    print(region)

for region in regions.keys():
    print(region)

for city in regions.values():
    print(city)

for region, city in regions.items():
    print(f'Région {region} dont le chef lieu est {city}')

# Non recommandé, mais on peut le rencontrer
for region in regions.keys():
  print(f"Région {region} dont le chef lieu est {regions[region]}")
```

## Recherche d'un élément

```python
countries = ['Allemagne', 'Espagne', 'France']

# Solution simple
if 'Allemagne' in countries:
    print('Présent')
else:
    print('Non présent')

# Plus complexe, avec une fonction pour les minuscules
present = False
for country in countries:
    if country.lower() == 'allemagne':
        present = True
if present:
    print('Présent')
else:
    print('Non présent')


# Le plus pythonique
for country in countries:
    if country.lower() == 'allemagne':
        print('Présent')
        break
else:
    print('Non présent')

# Encore plus pythonique avec une list-comprehension, voir plus bas
```

## Boucle while

Contrairement à la boucle `for`, on ne connait pas forcément le nombre d'exécution de la boucle en lisant uniquement
la ligne `while`.

```python
x = 0
while x < 10:
    print(x)
    x += 1
```

!!! error
    Attention à ne pas faire une **boucle infinie** !

* En Python, il n'y a pas de boucle `do ... while`, à la place, on peut faire ainsi :

```python
executer_une_fonction()
while not conditon_echec:
    executer_une_fonction()
```

## Switch

**Python 3.10** **minimum**

```python
numero_jour = 2

match numero_jour:
  case 1:
    print('Lundi')
  case 2:
    print('Mardi')
  case 3:
    print('Mercredi')
  case 4:
    print('Jeudi')
  case 5:
    print('Vendredi')
  case 6:
    print('Samedi')
  case 7:
    print('Dimanche')
  case _:
    print('Pas un jour de la semaine')

```

??? "Avant Python 3.10 avec un `if elif`"
	```python
	numero_jour = 2
	
	if numero_jour == 1:
		print('Lundi')
	elif numero_jour == 2:
		print('Mardi')
	elif numero_jour == 3:
		print('Mercredi')
	elif numero_jour == 4:
		print('Jeudi')
	elif numero_jour == 5:
		print('Vendredi')
	elif numero_jour == 6:
		print('Samedi')
	elif numero_jour == 7:
		print('Dimanche')
	else:
		print('Pas un jour de la semaine')
	```

## List Comprehensions

C'est une façon très pythonique et très utilisée de créer des listes.

### Pour transformer une liste existante, en la remplaçant :

```python
countries = ['Allemagne', 'Espagne', 'France']
countries = [c.upper() for c in countries]
```

<!-- La même solution sans la liste de compréhension : -->

Par exemple, créer une liste des nombres impairs entre 1 et 9 :

```python
# Non pythonique
impair = []
for x in range(10):
    if x % 2:
        impair.append(x)

# Pythonique
impair = [x for x in range(10) if x % 2]
```

* Il existe aussi les Dict Comprehensions (moins utilisé)

## Manipulation sur les chaînes de caractères

Slicing sur les mois de l'année :

```python
mois = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Octobre', 'Novembre', 'Décembre']

mois[0:2]
['Janvier', 'Février']

mois[2:]
['Mars', 'Avril', 'Mai', 'Juin', 'Octobre', 'Novembre', 'Décembre']

mois[:-2]
['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Octobre']

mois[-2:]
['Novembre', 'Décembre']
```

* Pour information, les chaînes de caractères sont des listes et on peut faire du **slicing** sur des listes :

```python
alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
len(alphabet)
','.join(alphabet)
alphabet.lower()
alphabet.upper()
alphabet[1]  # B
alphabet[1:3]  # BC
alphabet[-1]  # Z
alphabet[-3:]  # XYZ
alphabet[:6]  # ABCDEF
```

## Fonctions

<!-- REVOIR -->

Une fonction permet de factoriser son code. Elle peut :

* ne pas prendre de paramètre en **entrée**
* prendre un ou plusieurs paramètres en **entrée**
* ces entrées peuvent avoir des valeurs par défaut, on n'est donc pas obligé de les fournir de lors **l'appel** de la fonction
* une fonction peut ne **rien** retourner, (pas d'instructions `return` ou alors `return None`)
* ou alors retourner une ou plusieurs valeurs (cela sera implicitement une liste)

* Voici des exemples de fonction Python.
*Encore une fois*, attention à l'indentation !

```python
def ajouter(x, y):
    """Ajouter deux nombres."""
    return x + y

def crier(phrase='bonjour'):
    print(phrase.upper())

def discuter(texte, personnage='Charles'):
    """Un personnage discute."""
    print('{}: "{}"'.format(personnage, texte))

def discuter(texte, personnage='Charles'):
    """Un personnage discute."""
    return f'{personnage}: "{texte}"'
```

* Une fonction peut retourner plusieurs valeurs :

```python
def decomposer(entier, diviser_par):
    """Retourne la partie entière et le reste d'une division."""
    partie_entiere = entier / diviser_par
    reste = entier % diviser_par
    return int(partie_entiere), reste
```

* Il se peut que l'on ne connaisse pas à l'avance le nombre précis d'arguments dans une fonction.
	* `args` est utilisé pour passer un nombre indéterminé d'argument à la fonction
	* `kwargs` est utilisé pour un nombre indéterminé d'arguments nommés

```python
def une_fonction(*args, **kwargs):
    print('Les arguments')
    for arg in args:
        print(arg)
    print('Les arguments non nommés')
    for key, value in kwargs.items():
        print('{} -> {}'.format(key, value))

une_fonction(1,2,3, text='Ma phrase')
```

## POO : Programmation Orientée Objet

Pour l'explication théorique, lire l'introduction dans le chapitre de [la console](console.md##rappel-sur-la-poo).

On peut introduire l'utilisation de la POO à l'aide de l'objet `Path`. La documentation de cette classe se trouve
[en ligne](https://docs.python.org/3/library/pathlib.html).

La librairie `Path` est installé de base avec Python.

La programmation orientée objet permet de **créer** un objet (on parle plus précisément d'instancier) puis on
peut **appeler des méthodes** sur cet objet.

Dans une console QGIS :

```python
from pathlib import Path
# Appel du "constructeur"
chemin = Path('.')
# La notation . est une chaîne de caractère particulière pour un OS demandant le dossier courant de l'exécution.
# On peut utiliser .. pour faire référence au dossier parent
print(chemin.absolute())
print(chemin.is_dir())
un_fichier = chemin / 'mon_projet.qgs'
print(un_fichier.exists())
print(un_fichier.name)
print(un_fichier.name)
print(chemin.joinpath('mon_projet.qgs').exists())
```

!!! tip
	Quand l'instruction se termine par des `()`, on dit que c'est une **méthode** de cet objet. Il s'agit d'une **fonction**,
	qui peut prendre ou non des paramètres et qui peut renvoyer ou non des résultats en sortie. 
	Quand l'instruction ne se termine pas par `()`, on accède à une **propriété** de l'objet.


Pour une application avec des objets QGIS, il faut lire le chapitre suivant sur [la console](./console.md#rappel-sur-la-poo)
ou encore la partie sur l'écriture d'un [script Processing](./script-processing.md).

## Exceptions

Lire le chapitre sur le [parcours des entités](./selection-parcours-entites.md#les-exceptions-en-python).

## Truc et astuces

### Passage par référence

!!! warning
    Attention au passage par référence :
	```python
	ma_liste_1 = [1, 2, 3]
	ma_liste_2 = ma_liste_1
	ma_liste_2.append(4)
	print(ma_liste_2)
	print(ma_liste_1)
	```

### Enumerate

Avoir un compteur lors de l'itération d'une liste :
```python
users = ['Tom', 'James', 'John']
for i, user in enumerate(users):
    print('{} -> {}'.format(i + 1, user))
```

## Annotations

Dans la suite de la formation, il est possible de voir des **annotations Python**.
Cela permet de spécifier le type des variables dans les paramètres des fonctions et/ou de définir le type de retour.

```python
from typing import Tuple
def decomposer(entier: int, diviser_par: int) -> Tuple[int, int]:
    """Retourne la partie entière et le reste d'une division."""
    partie_entiere = entier / diviser_par
    reste = entier % diviser_par
    return int(partie_entiere), reste
```

Il faut lire la documentation des [annotations](https://docs.python.org/3/library/typing.html) pour voir les différentes
possibilités.

## Terminologie

* Package
* Module
* Classe
* Instance / Objet
* Variable
