package phinguyen.de.etl

import org.apache.spark.sql.{SaveMode, SparkSession}

import java.util.Properties

object PostgresToRaw {
  def main(args: Array[String]): Unit = {

    // Initialize SparkSession
    val spark = SparkSession.builder()
      .appName("Postgres To HDFS Ingestion")
      .master("spark://spark-master:7077")
      .config("spark.executor.memory", "2g")
      .config("spark.executor.cores", "2")
      .getOrCreate()

    // PostgreSQL connection properties
    val jdbcUrl = "jdbc:postgresql://postgres:5432/postgres"
    val connectionProperties = new Properties()
    connectionProperties.setProperty("user", "admin")
    connectionProperties.setProperty("password", "password123")
    connectionProperties.setProperty("driver", "org.postgresql.Driver")

    // Read table `actor` from dvdrental database
    val actorDf = spark.read.jdbc(jdbcUrl, "public.actor", connectionProperties)
    actorDf.write.mode(SaveMode.Overwrite).parquet("hdfs://namenode:8020/raw/actor")

    // Stop the Spark session
    spark.stop()
  }

}
