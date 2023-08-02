variable "project" {
  description = "GCP project"
  type        = string
  default     = "gcda-dev"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone suffix"
  type        = string
  default     = "a"
}

variable "workspace_name_override" {
  type        = string
  default     = ""
}

variable "k8s_api_sources" {
  description = "List of CIDR subnets which can access the Kubernetes API endpoint"
  default     = ["0.0.0.0/0"]
}

variable "cluster_ipv4_cidr_block" {
  description = "The IP address range of the container pods in this cluster, in CIDR notation. See https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#cluster_ipv4_cidr_block"
  default     = ""
}


variable "avalanche_fullnode_instance_type" {
  description = "Instance type used for Avalanche fullnode"
  default     = "n2d-standard-8"
}

variable "avalanche_fullnode_instance_disk_size_gb" {
  description = "disk size for Avalanche fullnode"
  default     = "20"
}


