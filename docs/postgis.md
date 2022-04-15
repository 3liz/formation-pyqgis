# PostGIS

## Psycopg

En Python, il existe un package dédié à PostgreSQL, il s'agit de [Psycopg](https://www.psycopg.org/).
Il s'agit d'un package totalement indépendant de QGIS.

Exemple pour récupérer les tables présentes dans une base de données à l'aide de SQL

```python
import psycopg2

inspect_schema = "mon_schema"
connection = psycopg2.connect(
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
results = connection.executeSql("SELECT * FROM schema.table;")
print(results)

# Créer un schéma
connection.createSchema("mon_nouveau_schema")

# Lister les tables
connection.tables("un_schema")

# Afficher une table dans QGIS
connection.tableUri("schema", "table")

layer = QgsVectorLayer(connection.tableUri("schema", "table"), "Ma table", "postgres")
layer.loadDefaultStyle()  # Si un style par défaut existe dans votre base PG
QgsProject.instance().addMapLayer(layer)

# Charger le résultat d'un SELECT
# Notons l'usage des parenthèses autour du SELECT
uri = QgsDataSourceUri(connection.uri())
uri.setTable('(SELECT * FROM schema.table)')
uri.setKeyColumn('uid')

# Avec une geom
uri.setGeomColumn('geom')

layer = QgsVectorLayer(uri.uri(), 'Requête SELECT', 'postgres')
```

!!! tip "Exemple d'extension"
    Si besoin, l'extension [PgMetadata](https://github.com/3liz/qgis-pgmetadata-plugin) utilise exclusivement
    l'API "Base de données PG" de QGIS.
