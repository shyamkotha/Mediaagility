/*
provider "google-beta" {
  region = "us-central1
  zone   = "us-central1-a"
}
*/

module "kms" {
  source         = "./modules/kms"
  keyring_name   = var.keyring_name
  cryptokey_name = var.cryptokey_name
  project_id     = var.project_id
  location       = var.location
}

/*
module "db-migrate" {
  source    = "./modules/migrate"
source_ip = var.source_ip
source_user = var.source_user
source_pass = var.source_pass
source_db = var.source_db
bucket_name = var.bucket_name
private_name = var.private_name
private_ip_address = var.private_ip_address
ciphertext_dest_dbpass = var.ciphertext_dest_dbpass
ciphertext_source_dbendpoint = var.ciphertext_source_dbendpoint
ciphertext_source_dbusername = var.ciphertext_source_dbusername
ciphertext_source_dbpass = var.ciphertext_source_dbpass
location = var.locationdb_tier = var.db_tier
}
*/
