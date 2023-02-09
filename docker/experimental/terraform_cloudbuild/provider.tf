# Run `gcloud auth application-default login` in your shell before
provider "google" {
  project = var.project_id
}

terraform {
 backend "gcs" {
  # TODO: This has to be changed to match current project or passed as cli
  # argument: "-backend-config="bucket=bucket_id"
   bucket  = "core-ml-engprod-build-farm-tfstate"
   prefix  = "terraform/state"
 }
}