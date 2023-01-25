variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "project_id" {
  default = "gap-terraform-iam"
}

# variable "gcp_zone" {
#   description = "GCP zone, e.g. us-east1-a"
#   default     = "us-east1-b"
# }

variable "machine_type" {
  description = "GCP machine type"
  default     = "n1-standard-1"
}

variable "instance_name" {
  description = "GCP instance name"
  default     = "lloyds-test"
}

variable "image" {
  description = "image to build instance from"
  default     = "debian-cloud/debian-11"
}