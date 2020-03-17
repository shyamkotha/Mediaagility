resource "google_storage_bucket" "sql_storage" {
  name     = "${var.bucket_name}"
  location = "EU"
}

resource "google_storage_bucket_object" "sql-backup" {
  depends_on = [null-resource.sp]
  name       = "db_dump.sql"
  source     = "./db_dump.sql"
  bucket     = "${google_storage_bucket.sql_storage.name}"
}

resource "google_storage_bucket_iam_member" "editor" {
  depends_on = [google_storage_bucket_object.sql-backup]
  bucket     = "${google_storage_bucket.sql_storage.name}"
  role       = "roles/storage.admin"
  member     = "serviceAccount:${google_sql_database_instance.instance.service_account_email_address}"
}

