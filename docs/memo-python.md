# Introduction au language Python

## Qu'est-ce que Python ?

* Multi-usage (WEB, application graphique, script, serveur etc)
* Programmation Orientée Objet (POO)
	* Tout est objet
* Interprété
* Centré sur la lecture et la productivité
	* Syntaxe du code simple
* Grosse communauté
	* De nombreux packages disponibles sur internet
	* https://pypi.org/

```python
# Déclaration d'une variable de type entier
x = 5

# Déclaration d'une variable chaîne de caractère
info = 'X est compris entre 0 et 10'

if 0 < x < 10:
	print(info)
```

## Versions

* Python 2
	* Sortie en 2000
	* Il est encore très utilisé, notamment sur les tutoriels sur internet et quelques projets qui tardent à
	 se mettre à jour
	* Une adoption massive (QGIS 2)
	* Dernière version le 1 janvier 2020
* Python 3
    * Sortie en 2008, mais il s'agit d'une adoption très lente, tellement Python 2 a été massivement adopté.
    * Dernière version 3.10.0 du 4 octobre 2021
    * 1 version majeure par an, en octobre
    * QGIS 3 requière :
        * Python 3.5 minimum for QGIS 3.4
        * Python 3.6 minimum for QGIS 3.18
        * Python 3.7 minimum for QGIS 3.20

## Rappel de base sur Python

* Un mémo Python plus important : https://www.w3schools.com/python/
* Un cours Python : https://openclassrooms.com/fr/courses/4262331-demarrez-votre-projet-avec-python

## Les types de données

Une variable peut contenir un entier, un booléen (`True` ou `False`), chaîne de caractères, nombre décimal, un
objet...
Il y a un faible typage des variables, c'est-à-dire qu'une variable peut changer de type au cours de l'exécution
du programme.

```python
mon_compteur = 0
type(mon_compteur)
<class 'int'>
mon_compteur = False
type(mon_compteur)
<class 'bool'>
mon_compteur = 'oui'
type(mon_compteur)
<class 'str'>
mon_compteur = "non"
type(mon_compteur)
<class 'str'>
mon_compteur = 3.5
type(mon_compteur)
<class 'float'>
mon_compteur = None
type(mon_compteur)
<class 'NoneType'>

```

## Les structures de données

Il existe quatre types de structure de données :

* les variables simples (ci-dessus)
* les tuples (non modifiables)

```python
liste_vide = ()
liste = (1 , 2, 3, 'bonjour')
type(liste)
<class 'tuple'>
len(liste)
4
liste[0]
1
liste[0:2]
(1, 2)
liste[2:]
(3, 'bonjour')
liste[5]
Traceback (most recent call last):
  File "/usr/lib/python3.7/code.py", line 90, in runcode
    exec(code, self.locals)
  File "<input>", line 1, in <module>
IndexError: tuple index out of range

```
* les listes (modifiables)
```python
nombres = []
type(nombres)
<class 'list'>
nombres.append(1)
nombres.extend([2, 3, 4])
nombres
[1, 2, 3, 4]

```

* les dictionnaires

*Attention*, les dictionnaires ne sont pas ordonnés !
Si vraiment il y a besoin, il existe une classe `OrderedDict`, mais ce n'est pas un structure de données natif
dans Python.
C'est un objet.

```python
personne = {}
type(personne)
# <class 'dict'>
personne['prenom'] = 'etienne'
personne['nom'] = 'trimaille'
personne['est_majeur'] = True
personne['age'] = 30
```

## Les commentaires

Pour commenter le code dans un script, pas dans la console : 

```python
# Ceci est un commentaire sur une ligne
/*
Ceci est
un commentaire
sur plusieurs lignes
*/

""" Ces lignes sont réservés pour la documentation de l'API et ne doivent pas être des lignes de commentaires. """

```

## Arithmétique

```python
a = 10
a += 1
a -= 1
b = a + 1
c = a - 1
d = a * 2
e = a / 2
f = a % 3  # 1
g = a ** 2  # 100
```

## Concaténer des chaînes et des variables

Concaténer, c'est assembler des assembler des chaînes de caractères dans une seule et même sortie.
On peut concaténer des variables entre elles ou du textes.

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

Encore plus moderne avec Python 3.6 et `fstring`
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
a is b
a is not b
a in b
0 < a < 10
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

Utile lors que l'on connait le nombre de répétitions avant l'éxécution de la boucle.

```python
for x in range(10):
    print(x)
    
countries = ['Allemagne', 'Espagne', 'France']
for country in countries:
    print('Pays : {}'.format(country))

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
    print('Région {} dont le chef lieu est {}'.format(region, city))
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

# Encore plus pythonique avec une list-comprehension
```

## Boucle while

```python
x = 0
while x < 10:
    print(x)
    x += 1
```

* En Python, il n'y a pas de boucle `do ... while`, à la place, on peut faire ainsi :

```python
executer_une_fonction()
while not conditon_echec:
    executer_une_fonction()
```

## Switch

**Python 3.10** uniquement



## List Comprehensions

C'est une façon très pythonique et très utilisée de créer des listes.
Par exemple, créer une liste des nombres impaires entre 1 et 9 :

```python
# Non pythonique
impair = []
for x in range(10):
    if x % 2:
        impair.append(x)

# Pythonique
impair = [x for x in range(10) if x % 2]
```

Autre exemple en transformant une liste :

```python
countries = ['Allemagne', 'Espagne', 'France']
countries = [c.upper() for c in countries]
```

* Il existe aussi les Dict Comprehensions (moins utilisé)

## Manipulation sur les chaînes de caractères

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
```

* Une fonction peut retourner plusieurs valeurs :

```python
def decomposer(entier, diviser_par):
    """Retourne la partie entière et le reste d'une division."""
    partie_entiere = entier / diviser_par
    reste = entier % diviser_par
    return partie_entiere, reste
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

## Truc et astuces

!!! warning
    Attention au passage par référence :
	```python
	ma_liste_1 = [1, 2, 3]
	ma_liste_2 = ma_liste_1
	ma_liste_2.append(4)
	print(ma_liste_2)
	print(ma_liste_1)
	```

Avoir un compteur lors de l'itération d'une liste :
```python
users = ['Tom', 'James', 'John']
for i, user in enumerate(users):
    print('{} -> {}'.format(i + 1, user))
```
