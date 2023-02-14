
resource "google_compute_network" "vpc_network" {
  name = "gcppoc-vpc"
}


resource "google_compute_subnetwork" "subnet" {
  name          = "gcppoc-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.name
}


resource "google_compute_firewall" "ssh_ingress" {
  name    = "ssh-ingress"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["38.242.174.140/0"]
}

resource "google_compute_firewall" "full_egress" {
  name    = "full-egress"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
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
    subnetwork = google_compute_subnetwork.subnet.name


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
    run = "test"

  }

  allow_stopping_for_update = true
  # service_account {
  #   # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #   email  = google_service_account.default.email
  #   scopes = ["cloud-platform"]
  # }
}


