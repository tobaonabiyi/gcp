terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.43.0"
    }
  }
}

provider "google" {
  project     = var.prj_id
  region      = var.region
  credentials = var.service_account
}
