terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.76.0"
    }
  }
}

provider "google" {
  project = "ca-qulijing-edu"
  region = "asia-northeast1"
  zone = "asia-northeast1-b"
}
//service_account
resource "google_service_account" "sa-tf" {
    account_id = "celeryteamb"
    display_name = "CeleryTeamb"
}
//compute instance
resource "google_compute_instance" "vm_instance" {
  name = "terraform-instance"
  zone = "asia-northeast1-b"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts-arm64"
      size = 20
    }
  }

  network_interface {
    network = "custom-terraform-vpc"
    subnetwork = "tokyo"
  }

  service_account {
    email = "celeryteamb@プロジェクトID.iam.gserviceaccount.com"
    scopes = [ "cloud-platform" ]
  }
}