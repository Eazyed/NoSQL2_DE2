CREATE TABLE eventData(
id_evt STRING COMMENT 'id technique de l’événement',
date_system_evt  STRING COMMENT 'date technique d’insertion de l’événement dans le SI',
date_occur_evt  STRING COMMENT 'date métier d’occurrence de l’événement',
date_occur_evt_formatted  STRING COMMENT 'date métier d’occurrence de l’événement, format YYYY-MM-DD',
type_evt STRING COMMENT 'type de l’événement ',
type_equipement STRING COMMENT 'type de l’équipement',
id_equipement STRING COMMENT 'id métier de l’équipement à l’origine de l’événement',
infos_div  STRING COMMENT 'texte libre')
COMMENT 'Table de réception des évènements'
PARTITIONED BY(DateStamp STRING)
STORED AS CSV;
