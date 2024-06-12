# PostGIS

## Psycopg

En Python, il existe un package dédié à PostgreSQL, il s'agit de [Psycopg](https://www.psycopg.org/).
Il s'agit d'un package totalement indépendant de QGIS.

Exemple pour récupérer les tables présentes dans une base de données à l'aide de SQL

```python
import psycopg

inspect_schema = "mon_schema"

connection = psycopg.connect(
    user="docker", password="docker", host="db", port="5432", database="gis"
)
cursor = connection.cursor()
cursor.execute(
    f"SELECT table_name FROM information_schema.tables WHERE table_schema = '{inspect_schema}'"
)
records = cursor.fetchall()
print(records)
```

## PyQGIS

Depuis QGIS 3.16, il existe de plus en plus de méthodes dans la classe
[QgsAbstractDatabaseProviderConnection](https://api.qgis.org/api/classQgsAbstractDatabaseProviderConnection.html)
pour interagir avec une base de données PostGIS.

```python
from qgis.core import QgsProviderRegistry

metadata = QgsProviderRegistry.instance().providerMetadata('postgres')
connection = metadata.findConnection("nom de la connexion PG dans votre panneau")

# Faire une requête SQL (ou plusieurs)
# Besoin d'échapper en utilisant "" si votre schéma ou table comporte des majuscules
results = connection.executeSql("SELECT * FROM \"schema\".\"table\";")
print(results)

# Créer un schéma
connection.createSchema("mon_nouveau_schema")

# Lister les tables
print(connection.tables("un_schema"))

# Afficher une table dans QGIS, cela retourne une chaîne de caractère
# permettant de faire une source de données pour une QgsVectorLayer
print(connection.tableUri("schema", "table"))

```

Afficher une table sans géométrie :

```python
layer = QgsVectorLayer(connection.tableUri("schema", "table"), "Ma table", "postgres")
layer.loadDefaultStyle()  # Si un style par défaut existe dans votre base PostgreSQL, avec la table layer_styles
QgsProject.instance().addMapLayer(layer)
```

Afficher une table avec géométrie en partant de `QgsDataSourceUri` :
```python
uri = QgsDataSourceUri(connection.uri())
uri.setSchema('schema')
uri.setTable('table')
uri.setKeyColumn('uid')

# Avec une geom si besoin
uri.setGeometryColumn('geom')

layer = QgsVectorLayer(uri.uri(), 'Ma table', 'postgres')
QgsProject.instance().addMapLayer(layer)
```

Afficher le résultat d'un `SELECT` :

```python
# Notons l'usage des parenthèses autour du SELECT
uri = QgsDataSourceUri(connection.uri())
uri.setTable('(SELECT * FROM schema.table)')
uri.setKeyColumn('uid')

# Avec une geom si besoin
uri.setGeometryColumn('geom')

layer = QgsVectorLayer(uri.uri(), 'Requête SELECT', 'postgres')
QgsProject.instance().addMapLayer(layer)
```

!!! tip "Exemple d'extension"
    Si besoin, l'extension [PgMetadata](https://github.com/3liz/qgis-pgmetadata-plugin) utilise exclusivement
    l'API "Base de données PG" de QGIS.
