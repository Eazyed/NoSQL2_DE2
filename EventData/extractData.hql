INSERT INTO TABLE eventData
  PARTITION (DateStamp=${hiveconf:date_metier}) -- R�cup�ration en config de la nouvelle cl� de partition
  SELECT *
  FROM eventDataStreaming AS eds
  WHERE eds.date = ${hiveconf:date_technique}  -- R�cup�ration en config de la date technique qui est la partition de la premi�re table
    AND  eds.date_occur_evt_formatted = ${hiveconf:date_metier}; -- On ne r�cup�re que les donn�es du jour sp�cifi� pour les ins�rer dans la bonne partition 

-- Une fois que les donn�es ont �t� transf�r�es on peut les supprimer de la table de streaming 
DELETE   
FROM eventDataStreaming AS eds
  WHERE eds.date = ${hiveconf:date_technique}  
    AND  eds.date_occur_evt_formatted = ${hiveconf:date_metier}; 