terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  # Optional: Use GCS backend for state management
  backend "gcs" {
    bucket = "your-tfstate-bucket"  # Create this bucket first
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Variables
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "bucket_name" {
  description = "Unique name for the storage bucket"
  type        = string
}

variable "region" {
  description = "GCP region for bucket location"
  type        = string
  default     = "us-central1"
}

# Create the Cloud Storage bucket
resource "google_storage_bucket" "my_bucket" {
  name                        = var.bucket_name
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  force_destroy               = false  # Prevents accidental deletion
  
  labels = {
    environment = "dev"
    managed-by  = "terraform"
  }
}

# Optional: Enable versioning
resource "google_storage_bucket_versioning" "my_bucket_versioning" {
  bucket = google_storage_bucket.my_bucket.name
}

# Output the bucket details
output "bucket_name" {
  value = google_storage_bucket.my_bucket.name
}

output "bucket_url" {
  value = google_storage_bucket.my_bucket.url
}
