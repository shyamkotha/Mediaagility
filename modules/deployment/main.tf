provider "google" {
  credentials = "${file("terraformtesting-262501-73b7bf8305a3.json")}"
  project     = "terraformtesting-262501"
  region      = "us-east1"
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

#  depends_on = [google_container_cluster.primary]
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
