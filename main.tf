terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# ADD THESE MISSING VARIABLES:
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "app_bucket_name" {
  description = "Application bucket name"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "asia-south1"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "app_bucket" {
  name          = var.app_bucket_name
  location      = var.region
  force_destroy = true
  
  labels = {
    environment = "learning"
    created-by  = "cloud-build"
  }
}

output "bucket_url" {
  value = google_storage_bucket.app_bucket.url
}
