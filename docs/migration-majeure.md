# Migration majeure au sein de PyQGIS

Lire la page recensant les ["breaking changes" de QGIS](https://api.qgis.org/api/api_break.html) de toutes les versions.

## QGIS 2 → QGIS 3

* QGIS 2, c'était Python 2 et Qt 4
* QGIS 3, Python 3 et Qt 5

[Petit guide](https://github.com/qgis/QGIS/wiki/Plugin-migration-to-QGIS-3) sur une migration vers QGIS 3.


## Qt 5 → Qt 6

QGIS va passer de la version Qt 5 vers Qt 6, en passant par la case QGIS 4.0. Même si il y a un changement de la version
"majeure" de la 3 vers la 4, il n'y a pas de réel "cassage" de l'API.

Le travail de migration a commencé depuis QGIS 3.34. Mais à l'heure actuelle, début 2025, il n'existe aucun binaire de
QGIS pour tester Qt 6. C'est pour le moment, "sous le capot" de QGIS que cela se passe.

Contrairement au passage Qt 4 vers Qt 5, il est possible de rendre une extension compatible pour les deux versions à
l'aide d'un script que l'on peut trouver dans
l'[autre petit guide](https://github.com/qgis/QGIS/wiki/Plugin-migration-to-be-compatible-with-Qt5-and-Qt6) pour une
migration vers Qt 6.

Par exemple, l'extension Lizmap avec le
[commit qui ajoute la compatibilité Qt 6](https://github.com/3liz/lizmap-plugin/commit/4b886ba1b90c86485049b5908dd1b045817c0695).

Lire l'[article de blog sur QGIS 4.0](https://blog.qgis.org/2025/04/17/qgis-is-moving-to-qt6-and-launching-qgis-4-0/).

Using [PyQGIS4-Checker](https://github.com/qgis/pyqgis4-checker) :

```bash
# Temporary hack 96aebf2d720a to have a working image
# docker pull ghcr.io/qgis/pyqgis4-checker:main
docker run --rm -v "$(pwd):/home/pyqgisdev/" 96aebf2d720a pyqt5_to_pyqt6.py --logfile /home/pyqgisdev/pyqt6_checker.log .
```
