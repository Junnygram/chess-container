terraform {
  required_version = "~> 1.1.9"
  backend "gcs" {
    
  }
  }
  provider "google" {
    project = var.project_id
    region = var.region
    
  }
