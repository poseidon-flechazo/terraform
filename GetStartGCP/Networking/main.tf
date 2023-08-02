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
//auto mode VPC network 
resource "google_compute_network" "vpc-network" {
    name = "vpc-network"
    auto_create_subnetworks = true
}
//custom mode VPC network
resource "google_compute_network" "custom-vpc-tf" {
    name = "custom-terraform-vpc"
    auto_create_subnetworks = false
}
//subnetwork
resource "google_compute_subnetwork" "tokyo" {
  name = "tokyo"
  network = google_compute_network.custom-vpc-tf.id
  ip_cidr_range = "10.0.0.0/24"
  region = "asia-northeast1"
  // private_ip_google_access = true
}
//firewall
resource "google_compute_firewall" "allow-ssh" {
  name = "allow-ssh"
  network = google_compute_network.custom-vpc-tf.id
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh"]
}

output "auto" {
  value = google_compute_network.vpc-network.id
}

output "custom" {
  value = google_compute_network.custom-vpc-tf.id
}