CREATE EXTERNAL TABLE eventData AS(
  SELECT
    ic.id_compteur,
    ic.pdc,
    ik.id_concentrateur,
    ik.pdk,
    commune.code_insee AS code_insee_compteur,
    commune.libelle_commune AS libelle_commune_compteur,
    departement.libelle_departement AS libelle_departement_compteur,
    region.libelle_region AS libelle_region_compteur,
    c2.code_insee AS code_insee_concentrateur,
    c2.libelle_commune AS libelle_commune_concentrateur,
    d2.libelle_departement AS libelle_departement_concentrateur,
    r2.libelle_region AS libelle_region_concentrateur,
  FROM installations_c ic
    JOIN pdc ON (pdc.pdc = ic.pdc)
    JOIN installations_k ik ON (pdc.pdk = ik.pdk AND DATE BETWEEN ik.date_debut AND ik.date_fin)
    JOIN pdk ON (pdk.pdk = ik.pdk)
    LEFT OUTER JOIN commune ON (commune.id_commune = pdc.id_commune)
    JOIN departement ON (departement.id_departement = commune.id_departement)
    JOIN region ON (region.id_region = departement.id_region)
    LEFT OUTER JOIN commune c2 ON (c2.id_commune = pdk.id_commune)
    JOIN departement d2 ON (d2.id_departement = c2.id_departement)
    JOIN region r2 ON (r2.id_region = d2.id_region)
  WHERE DATE BETWEEN ic.date_debut AND ic.date_fin
)
COMMENT 'Table du référentiel consolidé qui servira pour la jointure avec la table d evenement, elle n est pas partitione car elle ne contiendra que 40 M de lignes environ -> quelques Go'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
STORED AS TEXTFILE
LOCATION '/path/to/hdfs/'
