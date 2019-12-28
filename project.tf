provider "google" {
  credentials = "${file("terraformtesting-262501-73b7bf8305a3.json")}"
  project     = "terraformtesting-262501"
  region      = "us-east1"
}

# CREATING DATASET NAME

resource "google_bigquery_dataset" "default" {
  dataset_id                  = var.dataset_id
  friendly_name               = var.dataset_name
  description                 = "This is a test description"
  default_table_expiration_ms = 3600000

  labels = {
    env = "dev"
  }
}

# CREATING DATASET TABLE

resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = var.table_id

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

# configure kubectl with the credentials of the GKE cluster

resource "null_resource" "configure_kubectl" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.region} --project ${var.project}"

    }
  }

 
# DEPLOY TWITTER AND BIGQUERY APPLICATIONS
resource "kubernetes_deployment" "twitter" {
  metadata {
    name = "twitter-stream"
    labels = {
      App = "TwitterStream"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "TwitterStream"
      }
    }
    template {
      metadata {
        labels = {
          App = "TwitterStream"
        }
      }
      spec {
        container {
          name  = "twitter-to-pubsub"
          image = "gcr.io/google-samples/pubsub-bq-pipe:v5"

          env {
            name  = "PROCESSINGSCRIPT"
            value = "twitter-to-pubsub"
          }

          env {
            name  = "PUBSUB_TOPIC"
            value = "projects/terraformtesting-262501/topics/test1"
          }

          env {
            name  = "CONSUMERKEY"
            value = "mFrU14Qk7OGw09C3Ly6cnA2wM"
          }

          env {
            name  = "CONSUMERSECRET"
            value = "xGF25zWt2qrzkkql6nJiOP506dcUude5VWLGMjIbm3EmJNCeFk"
          }

          env {
            name  = "ACCESSTOKEN"
            value = "1210018508022484993-xNK3XPahNIiK3Fhd06stb5FDD67RWe"
          }
          env {
            name  = "ACCESSTOKENSEC"
            value = "UjRbyhxLC8kNeFGMjoNQVntdpVcpjmJAZcTGa6MvPNIwq"
          }
          env {
            name  = "TWSTREAMMODE"
            value = "sample"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "bigquery" {
  metadata {
    name = "bigquery-controller"
    labels = {
      App = "BigqueryController"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "BigqueryController"
      }
    }
    template {
      metadata {
        labels = {
          App = "BigqueryController"
        }
      }
      spec {
        container {
          name  = "bigquery"
          image = "gcr.io/google-samples/pubsub-bq-pipe:v5"

          env {
            name  = "PROCESSINGSCRIPT"
            value = "pubsub-to-bigquery"
          }

          env {
            name  = "PUBSUB_TOPIC"
            value = "projects/terraformtesting-262501/topics/test1"
          }

          env {
            name  = "PROJECT_ID"
            value = "terraformtesting-262501"
          }

          env {
            name  = "BQ_DATASET"
            value = "terraform"
          }

          env {
            name  = "BQ_TABLE"
            value = "service"
          }
        }
      }
    }
  }
}






