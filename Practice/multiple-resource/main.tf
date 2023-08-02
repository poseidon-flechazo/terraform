terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.76.0"
    }
  }
}

provider "google" {
  
}

resource local_file cat-res {
  filename = "cat.txt"
  content = " I love cats."
}

resource local_file dog-res {
  filename = "dog.txt"
  content = " I love dogs."
}