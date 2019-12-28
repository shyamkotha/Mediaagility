terraform {
  # The modules used in this example have been updated with 0.12 syntax, additionally we depend on a bug fixed in
  # version 0.12.7.
  required_version = ">= 0.12.9"
}

# PREPARE PROVIDERS


provider "google" {
 credentials = "${file("terraformtesting-262501-73b7bf8305a3.json")}"
 project = "terraformtesting-262501"
 region = "us-east1"
}

# CREATING DATASET NAME

resource "google_bigquery_dataset" "default" {
 dataset_id = var.dataset_id
 friendly_name = var.dataset_name
 description = "This is a test description"
 default_table_expiration_ms = 3600000

 labels = {
 env = "dev"
 }
}

# CREATING DATASET TABLE

resource "google_bigquery_table" "default" {
 dataset_id = google_bigquery_dataset.default.dataset_id
 table_id = var.table_id

 time_partitioning {
 type = "DAY"
 }

 labels = {
 env = "dev"
 }

 schema = "${file("${path.module}/schema.json")}"

}

# CREATING PUBSUB
 
resource "google_pubsub_topic" "default" {
 name = "test1"
labels = {
 foo = "bar"
 }
}

#CREATING CLUSTER

resource "google_container_cluster" "primary" {
 name = var.cluster_name
 location = var.location
 initial_node_count = 1


 node_config {
 oauth_scopes = [
 "https://www.googleapis.com/auth/pubsub",
 "https://www.googleapis.com/auth/bigquery",
 ]

 metadata = {
 disable-legacy-endpoints = "true"
 }
 }

 timeouts {
 create = "3m"
 update = "3m"
 }
}

# configure kubectl with the credentials of the GKE cluster

resource "null_resource" "configure_kubectl" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.region} --project ${var.project}"

    # Use environment variables to allow custom kubectl config paths
    environment = {
      KUBECONFIG = var.kubectl_config_path != "" ? var.kubectl_config_path : ""
    }
  }

  depends_on = [google_container_cluster.primary]
}

module "deployment" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-cluster?ref=v0.2.0"
  source = "./modules/deployment"
  project = "terraformtesting-262501"
  #depends_on = [google_container_cluster.primary]  
 }
