CREATE EXTERNAL TABLE consolidatedIndicatorData.hql(
pdk  STRING COMMENT 'identifiant du point de concentration',
date_indicator  STRING COMMENT 'date de l indicateur',
nb_event INT COMMENT'Nombre d evenement',
Commune STRING COMMENT 'Nom de la commune ',
Departement STRING COMMENT 'Nom du d�partement',
Region STRING COMMENT 'Nom de la r�gion')
COMMENT 'Table de donn�es consolid�es qui sera requ�t�e via le connecteur Hive de tableau Server'
PARTITIONED BY(date_indicator STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
STORED AS TEXTFILE
LOCATION '/path/to/hdfs/'
