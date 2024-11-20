# Migration majeure au sein de PyQGIS

Lire la page recensant les ["breaking changes" de QGIS](https://api.qgis.org/api/api_break.html) de toutes les versions.

## QGIS 2 → QGIS 3

* QGIS 2, c'était Python 2 et Qt 4
* QGIS 3, Python 3 et Qt 5

[Petit guide](https://github.com/qgis/QGIS/wiki/Plugin-migration-to-QGIS-3) sur une migration vers QGIS 3.


## Qt 5 → Qt 6

QGIS tente de passer de la version Qt 5 vers Qt 6, sans passer par la case QGIS 4.0 (et donc non "cassage" de l'API
QGIS 3.X).

Le travail de migration a commencé depuis QGIS 3.34. Mais à l'heure actuelle, fin 2024, il n'existe qu'un binaire de
QGIS pour tester Qt 6. C'est pour le moment, "sous le capot" de QGIS que cela se passe. 

Contrairement au passage Qt 4 vers Qt 5, il est possible de rendre une extension compatible pour les deux versions à
l'aide d'un script que l'on peut trouver dans
l'[autre petit guide](https://github.com/qgis/QGIS/wiki/Plugin-migration-to-be-compatible-with-Qt5-and-Qt6) pour une
migration vers Qt 6.

Par exemple, l'extension Lizmap avec le
[commit qui ajoute la compatibilité Qt 6](https://github.com/3liz/lizmap-plugin/commit/4b886ba1b90c86485049b5908dd1b045817c0695).
