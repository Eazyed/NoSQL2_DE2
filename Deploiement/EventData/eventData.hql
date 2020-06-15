CREATE TABLE eventData(
id_evt STRING COMMENT 'id technique de l��v�nement',
date_system_evt  STRING COMMENT 'date technique d�insertion de l��v�nement dans le SI',
date_occur_evt  STRING COMMENT 'date m�tier d�occurrence de l��v�nement',
date_occur_evt_formatted  STRING COMMENT 'date m�tier d�occurrence de l��v�nement, format YYYY-MM-DD',
type_evt STRING COMMENT 'type de l��v�nement ',
type_equipement STRING COMMENT 'type de l��quipement',
id_equipement STRING COMMENT 'id m�tier de l��quipement � l�origine de l��v�nement',
infos_div  STRING COMMENT 'texte libre')
COMMENT 'Table de r�ception des �v�nements'
PARTITIONED BY(DateStamp STRING)
STORED AS CSV;
