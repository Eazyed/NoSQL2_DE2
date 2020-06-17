CREATE EXTERNAL TABLE eventData(
id_compteur STRING COMMENT 'identifiant de l equipement communiquant',
pdc STRING COMMENT 'identifiant du point de comptage',
pdk  STRING COMMENT 'identifiant du point de concentration',
code_insee  STRING COMMENT 'Code insee de  la commune',
libelle_commune STRING COMMENT 'Nom de la commune ',
libelle_departement STRING COMMENT 'Nom du département',
libelle_region STRING COMMENT 'Nom de la région')
COMMENT 'Table du référentiel consolidé qui servira pour la jointure avec la table d evenement, elle n est pas partitione car elle ne contiendra que 40 M de lignes environ -> quelques Go'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
STORED AS TEXTFILE
LOCATION '/path/to/hdfs/'
