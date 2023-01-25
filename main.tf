
terraform {
  #   backend "gcs" {
  #     bucket  = "<iam-storage>"
  #  prefix  = "terraform/state"
  #   }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.55.0"
    }
  }
}


provider "google" {
  credentials = file("credentials.json")
  project     = var.project_id
  region      = var.region

  zone = var.zone
}

# resource "google_compute_network" "vpc_network" {
#   name = "test-network-gcp"

# }

# resource "google_service_account" "default" {
#   account_id   = "gap-terraform-iam-f3c0c2f8f0f2.json"
#   display_name = "Service Account"
# }
resource "google_compute_network" "vpc_network" {
  name = "dev-work-prj-vpc"
}

resource "google_compute_subnetwork" "public-subnetwork" {
  name          = "dev-work-prj-sub"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.public-subnetwork.name


    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  labels = {
    name  = var.instance_name
    owner = "lloyds"
    ttl   = "-1"
    # run   = "test"
    run ="test"
    
  }

  allow_stopping_for_update = true
  # service_account {
  #   # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #   email  = google_service_account.default.email
  #   scopes = ["cloud-platform"]
  # }
}


