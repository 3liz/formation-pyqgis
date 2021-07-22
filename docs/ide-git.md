# Python avancé

## Utilisation d'un IDE

Pour écrire du code Python, on peut utiliser n'importe quel éditeur de texte brut quelque soit l'OS.
Cependant, l'utilisation d'un éditeur de texte qui "comprend" le code Python est vivement recommandé car il
peut vous signaler quelques erreurs facilement détectables, tel que les imports manquants.
Comme éditeur de texte, il en existe plusieurs.

Si vous souhaitez faire plus de programmation, nous vous recommandons l'utilisation d'un IDE. Il embarque
l'éditeur de texte ci-dessus mais possède aussi des outils de debugs et d'assistance dans l'écriture du code
comme l'autocomplétion.

En IDE gratuit, il existe : 

* [Visual Studio](https://code.visualstudio.com/) en ajoutant les extensions Python
* [PyCharm Community](https://www.jetbrains.com/fr-fr/pycharm/), dédié au language Python

## Lancer un script Python dans la console

Si vous utilisez un IDE pour écrire du code Python, vous pouvez lancer le code Python
dans la console Python à l'aide de cette astuce.

* Ouvrir l'éditeur de script Python (pas juste la console)
* Tapez `print("bonjour")` dans le panneau de droite
* Lancer le script avec la flèche verte
* Copier/coller la ligne qui permet de lancer le script et modifier le chemin pour pointer vers le fichier sur votre disque. Elle ressemble à `exec(open('/chemin/vers/fichier.py'.encode('utf-8')).read())`.

## Utilisation de GIT

Il est vivement recommandé d'utiliser GIT :

 * sauvegarde de son code sur un serveur
 * versionner son code et suivre les modifications
 * simplifier le travail d'équipe

La documentation : https://git-scm.com/docs/

Les commandes les plus utiles :

 * `git commit` : https://git-scm.com/docs/git-commit/fr
 * `git add` : https://git-scm.com/docs/git-add/fr
 * `git push` : https://git-scm.com/docs/git-push/fr
 * `git pull` : https://git-scm.com/docs/git-pull/fr

Liens vers OpenClassRooms :

  * https://openclassrooms.com/fr/courses/1233741-gerez-vos-codes-source-avec-git
  * https://openclassrooms.com/fr/courses/5641721-utilisez-git-et-github-pour-vos-projets-de-developpement
