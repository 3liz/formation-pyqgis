# Documentation et liens utiles

* QGIS est composé de plusieurs centaines de classes écrites en C++.
La plupart de ces classes (et donc des fonctions) sont accessibles à travers un API en Python.
Comme il n'est pas possible de mémoriser entièrement l'API de QGIS, il est nécessaire de connaître la
documentation et comment rechercher des informations.
* QGIS 3 repose sur la librairie **Qt version 5** pour l'interface graphique et sur **Python version 3**.
* Toutes les classes QGIS commencent par `Qgs` et toutes les classes Qt commencent par `Q`.

!!! tip
    QGIS est en train de migrer vers la librairie Qt version 6. QGIS 3.42 va _certainement_ avoir un support pour Qt6
    et pouvoir faire des premiers tests PyQGIS. Lire le
    [chapitre sur les migrations majeures de PyQGIS](./migration-majeure.md).

Voici une liste de liens pour la documentation, tous en anglais, sauf le cookbook :

* [https://docs.qgis.org](https://docs.qgis.org) qui regroupe :
    * [Le Python Cookbook https://docs.qgis.org/latest/fr/docs/pyqgis_developer_cookbook](https://docs.qgis.org/latest/fr/docs/pyqgis_developer_cookbook/) (recette de cuisine)
    * [L'API C++ https://qgis.org/api/3.34/](https://qgis.org/api/3.34/)
    * [L'API Python https://qgis.org/pyqgis/3.34/](https://qgis.org/pyqgis/3.34/)
* [Documentation de l'API Qt](https://doc.qt.io/qt-5/classes.html)
* [Documentation de Python](https://docs.python.org/3/library/)
    * [Le module Pathlib](https://docs.python.org/3/library/pathlib.html#module-pathlib), "nouveau" module pour manipuler des chemins
    * [Le module os.path](https://docs.python.org/3/library/os.path.html#module-os.path), module "historique" pour manipuler des chemins

Voici une liste non exhaustive de blog-post utiles pour manipuler PyQGIS, tous en anglais :

* [Cours PyQGIS de SpatialThoughts](https://courses.spatialthoughts.com/pyqgis-masterclass.html)
* [Optimisation des couches vecteurs](https://nyalldawson.net/2016/10/speeding-up-your-pyqgis-scripts/)
* [Parcourir la légende en 3 parties](https://www.lutraconsulting.co.uk/blog/2014/07/06/qgis-layer-tree-api-part-1/)
* [Plugin Processing](http://www.qgistutorials.com/en/docs/3/processing_python_plugin.html)
* [Workshop sur les expressions en Python](https://madmanwoo.gitlab.io/foss4g-python-workshop/)

Autre lien pour l'apprentissage de Python (sans QGIS) en français :

* [https://openclassrooms.com/fr/courses/235344-apprenez-a-programmer-en-python](https://openclassrooms.com/fr/courses/235344-apprenez-a-programmer-en-python)

!!! tip
    QGIS 3.42 va intégrer un outil pour avoir l'aide d'une classe directement depuis une variable.
    Voir la [démo](https://github.com/qgis/QGIS/pull/58962) de QGIS 3.42.