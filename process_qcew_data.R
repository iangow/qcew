years <- 2001:2024L

get_qcew_zip_data <- function(year, schema = "qcew",
                              data_dir = NULL,
                              raw_data_dir = NULL) {

  if (is.null(raw_data_dir)) {
    raw_data_dir <- file.path(Sys.getenv("RAW_DATA_DIR"), schema)
  }

  if (!dir.exists(raw_data_dir)) dir.create(raw_data_dir, recursive = TRUE)

  url <- stringr::str_glue("https://data.bls.gov/cew/data/files/{year}",
                           "/csv/{year}_annual_singlefile.zip")
  t <- file.path(raw_data_dir, basename(url))
  if (!file.exists(t)) download.file(url, t)
  return(TRUE)
}

res <- lapply(years, get_qcew_zip_data)

process_qcew_data <- function(year, schema = "qcew", data_dir = NULL,
                              raw_data_dir = NULL) {

  if (is.null(raw_data_dir)) {
    raw_data_dir <- file.path(Sys.getenv("RAW_DATA_DIR"), schema)
  }

  if (is.null(data_dir)) data_dir <- Sys.getenv("DATA_DIR")
  data_dir <- file.path(data_dir, schema)
  if (!dir.exists(data_dir)) dir.create(data_dir, recursive = TRUE)

  filename <- stringr::str_glue("{year}_annual_singlefile.zip")
  t <- path.expand(file.path(raw_data_dir, filename))
  csv_file <- unzip(t)

  pq_file <- stringr::str_glue("annual_{year}.parquet")
  pq_path <- path.expand(file.path(data_dir, pq_file))
  db <- DBI::dbConnect(duckdb::duckdb())

  args = ", types = {'year': 'INTEGER'}"

  sql <- stringr::str_glue("COPY (SELECT * FROM read_csv('{csv_file}'{args})) ",
                           "TO '{pq_path}' (FORMAT parquet)")

  res <- DBI::dbExecute(db, sql)
  DBI::dbDisconnect(db)
  unlink(csv_file)
  res
}

res <- lapply(years[1], process_qcew_data)
