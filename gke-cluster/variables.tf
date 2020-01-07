variable "project" {
  description = "The project ID where all resources will be launched."
  type        = string
  default     = "terraformtesting-262501"
}

variable "credentials_path" {
  description = "Path to a Service Account credentials file with permissions documented in the readme"
  default     = "terraformtesting-262501-73b7bf8305a3.json"
}

variable "region" {
  description = "The region to deploy resources in"
  default     =  "us-east1"
}

variable "random_project_id" {
  description = "Whether to append a random suffix to the created project"
  default     = "true"
}

variable "dataset_id" {
  description = "Unique ID for the dataset being provisioned."
  default     = "terraform"
}

variable "dataset_name" {
  description = "Friendly name for the dataset being provisioned."
  type        = string
  default     = "testing-dataset"
}

variable "project_id" {
  type        = string
  description = "The project ID to manage the Pub/Sub resources" 
  default     = "terraformtesting-262501"
}

variable "topic_name" {
  type        = string
  description = "The name for the Pub/Sub topic"
  default     = "test1"
}

variable "topic_labels" {
  type        = map(string)
  description = "A map of labels to assign to the Pub/Sub topic"
  default     = {}
}

variable "bq_location" {
  description = "The regional location for the dataset only US and EU are allowed in module"
  type        = string
  default     = "US"
}

variable "default_table_expiration_ms" {
  description = "TTL of tables using the dataset in MS"
  default     = null
}

variable "table_id" {
  description = "Unique ID for table"
  type        = string
  default     = "service"
}

variable "image" {
  default = "debian-cloud/debian-9"
}

variable "us_instance" {
  default = "testing-vm"
}

variable "node_pool_name" {
  default = "gke-nodepool"
}

variable "node_count" {
  default = 3 
}

variable "disk_size_gb" {
  default = 50
}

variable "vm_type" {
  default = "COS_CONTAINERD"
}

variable "machine_type" {
  default = "n1-standard-1"
}

#variable "cluster_labels" {
 # default = "dev"
#}

variable "bucket_name" {
  description = "Unique Storage Bucket name"
  default     = "project-service-dev-12344"
}

variable "location" {
  description = "Storage Bucket location"
  default     = "us-east1"
}

variable "storage_class" {
  description = "Storage Bucket class name"
  default     = "STANDARD"
}

variable "shared_vpc-network_name" {
  description = "The name of the network within which the Shared VPC Subnets reside"
  default     = "shared-network"
}

variable "shared_vpc-subnets" {
  type        = list(string)
  description = "The list of subnetworks within the shared VPC to attach this project to, e.g. 'projects/PROJECT_ID/regions/us-east1/subnetworks/default'"
  default     = []
}

variable "network_name" {
  description = "Name for Shared VPC network"
  default     = "shared-network"
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
  default     = "my-cluster"
}

variable "cluster_service_account_name" {
  description = "The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters."
  type        = string
  default     = "my-private-cluster-sa"
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type        = string
  default     = "Example GKE Cluster Service Account managed by Terraform"
}

variable "kubectl_config_path" {
  description = "Path to the kubectl config file. Defaults to $HOME/.kube/config"
  type        = string
  default     = ""
}
