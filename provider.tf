terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.83.0"
    }
  }

  backend "gcs" {
    bucket = "tf-backend-gcs"
    prefix = "terraform/state"
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

