resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  provider         = google-beta
  name             = "private-instance-${random_id.db_name_suffix.hex}"
  region           = "${var.location}"
  database_version = "MYSQL_5_7"
  depends_on       = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "${var.db_tier}"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.self_link
    }
  }
}

data "google_kms_secret" "sql_user_password" {
  crypto_key = google_kms_crypto_key.crypto_key.self_link
  ciphertext = "${var.ciphertext_dest_dbpass}"
}


resource "google_sql_user" "users" {
  name     = "${var.sql_user}"
  instance = google_sql_database_instance.instance.name
  password = data.google_kms_secret.sql_user_password.plaintext
}

