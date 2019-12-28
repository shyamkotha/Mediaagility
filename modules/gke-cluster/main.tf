provider "google" {
  credentials = "${file("terraformtesting-262501-73b7bf8305a3.json")}"
  project     = "terraformtesting-262501"
  region      = "us-east1"
}


#CREATING CLUSTER

resource "google_container_cluster" "primary" {
  name               = var.cluster_name
  location           = var.location
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
    create = "30m"
    update = "40m"
  }
}
