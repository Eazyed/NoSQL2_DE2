CREATE TABLE compteur
( 
  pdc STRING,
  id_compteur STRING,
  date_debut DATE,
  date_fin DATE
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
