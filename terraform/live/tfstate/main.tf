terraform {
  backend "gcs" {
    bucket = "gilbertotaccaricom-tfstate"
    prefix = "live/tfstate"
  }
}

provider "google" {
  project = "playground-326915"
  region  = "europe-west3"

  user_project_override = true
  billing_project       = "playground-326915"
}

data "google_project" "this" {
}

resource "google_storage_bucket" "this" {
  name          = "gilbertotaccaricom-tfstate"
  location      = "EU"
  force_destroy = false
  versioning {
    enabled = true
  }
  public_access_prevention = "enforced"
}
