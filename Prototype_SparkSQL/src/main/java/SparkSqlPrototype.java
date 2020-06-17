import static org.apache.spark.sql.functions.concat;
import static org.apache.spark.sql.functions.lit;

import java.util.Properties;

import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SaveMode;
import org.apache.spark.sql.SparkSession;

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

	    // Step 1: Ingestion
	    // ---------

	    // Reads a CSV file with header, called authors.csv, stores it in a
	    // dataframe
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
		    
		dfref.createOrReplaceTempView("referentialData");
		
		Dataset <Row> joined = dfevent.join(dfref, dfref.col("id_compteur").equalTo(dfevent.col("id_equipement")));
		dfref.createOrReplaceTempView("joined");

		Dataset <Row> aggregateByCompteur = spark.sql("Select j.id_compteur, count(*) from joined as j group by j.id_compteur");
		aggregateByCompteur.coalesce(1).write().csv("data/aggregateByCompteur");
		System.out.print(joined.head(10));
		
	    
	    
	}
}