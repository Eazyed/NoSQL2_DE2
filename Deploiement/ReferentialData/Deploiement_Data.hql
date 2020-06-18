CREATE TABLE compteur
( 
  pdc STRING COMMENT 'identifiant du point de comptage',
  id_compteur STRING COMMENT 'identifiant de l equipement communiquant',
  date_debut DATE COMMENT 'date métier d’installation de l’équipement sur ce point',
  date_fin DATE COMMENT 'date métier de fin (éventuellement nulle) d’installation de l’équipement sur ce point'
)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/installations_c');

CREATE TABLE concentrateur
( 
  pdk STRING,
  id_concentrateur STRING,
  date_debut DATE,
  date_fin DATE
)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/installations_k');
