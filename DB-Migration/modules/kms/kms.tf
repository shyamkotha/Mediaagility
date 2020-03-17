resource "google_kms_key_ring" "key_ring" {
  project  = "${var.project_id}"
  name     = "${var.keyring_name}"
  location = "${var.location}"
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "${var.cryptokey_name}"
  key_ring = google_kms_key_ring.key_ring.self_link
}



