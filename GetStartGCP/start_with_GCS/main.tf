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

resource google_storage_bucket "sb_tf"{
  name = "ca-qulijing-edu_terroform"
  location = "asia-northeast1"
  project = "ca-qulijing-edu"
}
