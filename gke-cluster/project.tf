terraform {
  # The modules used in this example have been updated with 0.12 syntax, additionally we depend on a bug fixed in
  # version 0.12.7.
  required_version = ">= 0.12.9"
}

#CREATING CLUSTER

resource "google_container_cluster" "gke-cluster" {
 name = var.cluster_name
 location = var.location
 initial_node_count = 1
 remove_default_node_pool = true
 resource_labels = {
  env = "dev"
 }

 addons_config {
   http_load_balancing {
     disabled = true
    }

   horizontal_pod_autoscaling {
     disabled = true
    }
  }
}

resource "google_container_node_pool" "np" {
  name       = "${var.node_pool_name}"
  location   = "${var.location}"
  cluster    = "${google_container_cluster.gke-cluster.name}"
  node_count = "${var.node_count}"
  
  node_config {
   preemptible  = false
   machine_type = "${var.machine_type}"
   disk_size_gb = "${var.disk_size_gb}"
   image_type   = "${var.vm_type}"
   
   oauth_scopes = [
     "https://www.googleapis.com/auth/pubsub",
     "https://www.googleapis.com/auth/bigquery",
     "https://www.googleapis.com/auth/devstorage.read_only",
     "https://www.googleapis.com/auth/logging.write",
     "https://www.googleapis.com/auth/monitoring",
   ]

   metadata = {
     disable-legacy-endpoints = "true"
   }
  }
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
  env = "dev"
 }
}

# configure kubectl with the credentials of the GKE cluster

resource "null_resource" "post_processor2" {
  depends_on = ["google_container_node_pool.np"]

  provisioner "local-exec" {
    command = "/bin/sh deploy.sh"

    environment = {
      CLUSTER_NAME = "${google_container_cluster.gke-cluster.name}"
      CLUSTER_ZONE = "${var.location}"
      NODE_COUNT   = "${var.node_count}"
    }
  }
}

data "google_client_config" "current" {}
