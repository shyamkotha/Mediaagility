variable source_db {
  description = "source data base name which we are going to take backup from"
}
variable bucket_name {
  description = "gcp bucket which is going to be created utilized for data migration"
}
variable private_name {
  description = "private vpc name which is going to be created"
}
variable private_ip_address {
  description = "the name declaration for private IP allocation to the private vpc"
}
variable keyring_name {
  description = "the name declaration for keyring which is going to be created and utilized for kms encryption "
}
variable cryptokey_name {
  description = "the key name for the keyring"
}
variable ciphertext_dest_dbpass {
  description = "ciphertext value for gcp destination db user password"
}
variable ciphertext_source_dbendpoint {
  description = "ciphertext value for source database endpoint/IP"
}
variable ciphertext_source_dbusername {
  description = "ciphertext value for source database username"
}
variable ciphertext_source_dbpass {
  description = "ciphertext value for source database password"
}
variable project_id {
  description = "Main Project IP where we are going to implement the entire setup"
}
variable location {
  description = "Enter the region value"
}
variable db_tier {
  description = "DB Machine type which is going to be created in gcp as target"
}
variable sql_user {
  description = "name of the sql user"
}
