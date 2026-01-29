terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  # NO BACKEND - Uses local state (perfect for learning!)
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "app_bucket" {
  name     = var.app_bucket_name
  location = var.region
  force_destroy = true  # Allows deletion during learning
  
  labels = {
    environment = "learning"
    created-by  = "cloud-build"
  }
}

output "bucket_url" {
  value = google_storage_bucket.app_bucket.url
}
