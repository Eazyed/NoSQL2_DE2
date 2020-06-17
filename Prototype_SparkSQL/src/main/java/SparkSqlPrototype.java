import static org.apache.spark.sql.functions.concat;
import static org.apache.spark.sql.functions.lit;

import java.util.Date;
import java.util.Properties;

import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SaveMode;
import org.apache.spark.sql.SparkSession;
import org.joda.time.DateTime;

public class SparkSqlPrototype {
	  public static void main(String[] args) {
			System.setProperty("hadoop.home.dir", "C:/tmp");
			SparkSqlPrototype app = new SparkSqlPrototype();
		    app.start();
		  }

	private void start() {
	    // Creates a session on a local master
	    SparkSession spark = SparkSession.builder()
	        .appName("CSV to CSV")
	        .master("local")
	        .getOrCreate();

	    // Ingestion
	    // ---------
	    Dataset<Row> dfevent = spark.read()
	        .format("csv")
	        .option("header", "true")
	        .option("sep", ";")
	        .load("data/eventData.csv");
	    
	    dfevent.createOrReplaceTempView("eventData");
	    
	    Dataset<Row> dfref = spark.read()
		        .format("csv")
		        .option("header", "true")
		        .option("sep", ";")
		        .load("data/referentialData.csv");
		DateTime date = new DateTime(2020,06,17,12,0,0);  
		// Selection d'une plage temporelle. On va toujours choisir un seul jour de donnée pour calculer les indicateurs
		// Et faire la jointure
		String dateDay = date.toString("yyyy-MM-dd");
		
		dfevent = spark.sql("select * from eventData where date_occur_evt_formatted = '"+dateDay+"'");
		
		// Jointure 
		// -----
		Dataset <Row> joined = dfevent.join(dfref, dfref.col("id_compteur").equalTo(dfevent.col("id_equipement")));
		joined.createOrReplaceTempView("joined");
		
		
		// ---- Formatage sous forme de table
		// Première étape récupération des indicateurs quotidiens par concentrateur par jour
		
		Dataset <Row> aggregateByPdk = spark.sql("select pdk,date_occur_evt_formatted,type_evt,count(*) as nb_event,first(libelle_commune) as Commune,first(libelle_departement) as Departement,first(libelle_region) as Region from joined as j group by j.pdk, j.date_occur_evt_formatted,j.type_evt order by j.pdk");
		Dataset <Row> aggregateByPdkTemp = aggregateByPdk;
		// Ici pour un jour donné on va  générer un nombre de lignes égal au nombre de pdk * le nombre de type d'évènements. On a 8000 pdk et un nombre indéterminé
		// de type d'évènement. On a quand même un ordre de grandeur inférieure au millionr.
		// Avec une table de cette structure partitionnée par date on aurait des partitions de tailles réduites.
		// Mais les requêtes étant toutes basées sur le temps, le partitionnement reste pertinent
		
		// On répète l'opération pour les 30 jours précédents
		for(int i=0;i<30;i++) {
			date = date.minusDays(1);
			dateDay = date.toString("yyyy-MM-dd");
			dfevent = spark.sql("select * from eventData where date_occur_evt_formatted = '"+dateDay+"'");
			joined = dfevent.join(dfref, dfref.col("id_compteur").equalTo(dfevent.col("id_equipement")));
			joined.createOrReplaceTempView("joined");
			aggregateByPdkTemp = spark.sql("select pdk,date_occur_evt_formatted,type_evt,count(*) as nb_event,first(libelle_commune) as Commune,first(libelle_departement) as Departement,first(libelle_region) as Region from joined as j group by j.pdk, j.date_occur_evt_formatted,j.type_evt order by j.pdk");
			aggregateByPdk = aggregateByPdk.union(aggregateByPdkTemp);
		}
		
		
		aggregateByPdk.coalesce(1).write().format("com.databricks.spark.csv").option("header", true).save("data/result");
		// Ce résultat va être mergé dans une table hive partitionnée par Date format yyyy-MM-dd.
	    // A partir de là la partie très coûteuse est passée on peut extraire les indicateurs  par des requêtes SQL de base sur la table Hive
		
	    
	}
}
