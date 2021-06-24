# La base pour créer une extension

Pour créer une extension dans QGIS, il existe deux façons de démarrer : 

* Utilisation de l'extension "Plugin Builder" :
    * Disponible depuis le gestionnaire des extensions de QGIS
    * Assistant de création
    * Très (trop) complet, il y a squelette pour :
        * Du code avec des actions, ...
        * Générer de la documentation Sphinx
        * Des tests unitaires
        * Les traductions (multilingue)
    * Très historique, moins mis à jour ces dernières années
* QGIS Minimal plugin : https://github.com/wonder-sk/qgis-minimal-plugin
    * ZIP à télécharger et à extraire
    * Très léger
    * Besoin de **tout** refaire depuis zéro

Nous pouvons suivre une des deux méthodes, mais dans le cadre de la formation, faisons la méthode minimale.
Dans les deux cas, le résultat doit être dans le dossier `python/plugins` du profil courant.

Pour trouver le profil courant, dans QGIS, `Profils Utilisateurs` -> `Ouvrir le dossier du profil actif`.

## Plugin reloader

Le "Plugin Reloader" est une extension indispensable pour développer une extension pour recharger son 
extension. Elle est disponible dans le gestionnaire des extensions.

## Apprendre d'une autre extension

Comme les extensions sur qgis.org sont disponibles sur internet, on peut regarder le code source pour
comprendre.
