Database Migration.

Steps:

1. Add our cloudshell public IP in source Security Group or Firewall

2. Apply the below variables value in terraform.tfvars
keyring_name  -  name of the kms keyring to be created
cryptokey_name   - crptokey name to be created

3. Run terraform plan and apply by cloudshell which will create the kms setup in GCP

4. Now KMS is available, Add below details in vault by the below comment
Needs to be added:
source_ip       -  Source database IP/Endpoint
source_user     -  Source database username
source_pass     -  Source database password
dest_pass       -  Destination database password to create a database user in gcp

ex:
echo -n "Valuetobeencrypted" | gcloud kms encrypt \ --project terraform-260119 \ --location us-central1 \ --keyring roswell \ --key roswell-crypto-key \ --plaintext-file - \ --ciphertext-file - \ | base64
you will get an output as an cipher text which will be used in the next step.

5. Gets the below details and assign the values in terraform.tfvars file

source_db       -  Source database/schema name which needs to be migrated
bucket_name     -  the bucket to store the database backup
private_name    -  Private network name
private_ip_address - Private ip address assign name
ciphertext_dest_dbpass  - You will get from the previous step
ciphertext_source_dbendpoint - You will get from the previous step
ciphertext_source_dbusername - You will get from the previous step
ciphertext_source_dbpass - You will get from the previous step

6. Comment KMS module and Uncomment Migrate module in main.tf

7. Run terraform plan and apply by cloudshell which will run the migration in GCP


