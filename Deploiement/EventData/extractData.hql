INSERT INTO TABLE eventData
  PARTITION (DateStamp=${hiveconf:date_metier}) -- Récupération en config de la nouvelle clé de partition
  SELECT *
  FROM eventDataStreaming AS eds
  WHERE eds.date = ${hiveconf:date_technique}  -- Récupération en config de la date technique qui est la partition de la première table
    AND  eds.date_occur_evt_formatted = ${hiveconf:date_metier}; -- On ne récupère que les données du jour spécifié pour les insérer dans la bonne partition 

-- Une fois que les données ont été transférées on peut les supprimer de la table de streaming 
DELETE   
FROM eventDataStreaming AS eds
  WHERE eds.date = ${hiveconf:date_technique}  
    AND  eds.date_occur_evt_formatted = ${hiveconf:date_metier}; 