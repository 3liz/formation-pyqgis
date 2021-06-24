# Comment déployer son extension

Comme vu dans le chapitre concernant la [création d'une extension générique](extension-generique.md), une
extension QGIS est un dossier comportant : 

* un dossier qui est `nom_du_module`:
    * `metadata.txt`
    * `__init__.py` avec `classFactory`
    * d'autres fichiers Python
    * des fichiers QtDesigner UI, SVG, couches etc

Ce dossier doit être zippé.

Pour du déploiement, nous recommandons l'usage de [QGIS-Plugin-CI](https://github.com/opengisch/qgis-plugin-ci)
qui peut faire du packaging, la génération du `plugins.xml`, envoyer sur
[plugins.qgis.org](https://plugins.qgis.org) etc.

## En interne

Si on souhaite publier en interne, on peut déposer son dossier zip sur un serveur et on recommande
l'utilisation du fichier `plugins.xml` qui permet de renseigner à QGIS la disponibilité d'une extension.

Exemple avec l'installation de
[PgMetadata](https://docs.3liz.org/qgis-pgmetadata-plugin/user-guide/installation/#custom-repository)
et son fichier
[plugins.xml](https://github.com/3liz/qgis-pgmetadata-plugin/releases/latest/download/plugins.xml)

Il est possible de protéger son dépôt avec un login/mot de passe.

## plugins.qgis.org

Plus simple pour le déploiement car le dépôt [plugins.qgis.org](https://plugins.qgis.org) est par défaut dans
les installations de QGIS. Il faut cependant que le code source soit disponible sur internet.

Lire [les recommandations](https://plugins.qgis.org/publish/) pour la publication sur ce dépôt :

* Code source disponible
* `metadata.txt` avec les bonnes informations et des liens HTTP valides
