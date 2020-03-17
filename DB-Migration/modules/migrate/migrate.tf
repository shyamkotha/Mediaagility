
data "google_kms_secret" "source_db_endpoint" {
  crypto_key = google_kms_crypto_key.crypto_key.self_link
  ciphertext = "${var.ciphertext_source_dbendpoint}"
}

data "google_kms_secret" "source_db_username" {
  crypto_key = google_kms_crypto_key.crypto_key.self_link
  ciphertext = "${var.ciphertext_source_dbusername}"
}

data "google_kms_secret" "source_db_password" {
  crypto_key = google_kms_crypto_key.crypto_key.self_link
  ciphertext = "${var.ciphertext_source_dbpass}"
}


resource "null_resource" "sp" {
  provisioner "local-exec" {
    command = "mysqldump -h data.google_kms_secret.source_db_endpoint.plaintext -u data.google_kms_secret.source_db_username.plaintext -B --events --routines --triggers --password=data.google_kms_secret.source_db_password.plaintext ${var.source_db} > ./db_dump.sql"
  }
}

resource "null_resource" "sp1" {
  depends_on = [google_storage_bucket_iam_member.editor]
  provisioner "local-exec" {
    command = "gcloud sql import sql ${google_sql_database_instance.instance.name} gs://${google_storage_bucket.sql_storage.name}/db_dump.sql -q"
  }
}

resource "null_resource" "sp2" {
  depends_on = [null_resource.sp1]
  provisioner "local-exec" {
    command = "rm -rf ./db_dump.sql"
  }
}
