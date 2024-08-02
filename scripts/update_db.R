nflfastR::update_db(
  dbdir = getOption("nflfastR.dbdirectory", default = "data"),
  dbname = "pbp_db",
  tblname = "nflfastR_pbp",
  force_rebuild = FALSE,
  db_connection = NULL
)


con <- DBI::dbConnect(RSQLite::SQLite(), 'data/pbp_db')

tmp <- dplyr::tbl(con, "nflfastR_pbp") |>
  dplyr::collect()


duck <- DBI::dbConnect(duckdb:::duckdb(), dbdir = 'data/football.duckdb')

DBI::dbExecute(duck, "CREATE SCHEMA IF NOT EXISTS BASE;")

DBI::dbWriteTable(duck, "BASE.NFLFASTR_PBP", tmp)

dplyr::tbl(duck, "BASE.NFLFASTR_PBP")
DBI::dbDisconnect(duck)
DBI::dbDisconnect(con)
