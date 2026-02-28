# Tell terraform to use the provider and select a version.
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.60"
    }
  }

  backend "s3" {
    bucket = "tobias-boyer-dev-state"
    key    = "terraform.tfstate"

    endpoints = {
      s3 = "https://b38de2d1c764240844658c43b3b6578b.eu.r2.cloudflarestorage.com"
    }

    # Using cloudflare r2 - disabling AWS specific checks
    region                      = "auto"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}

# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {
  sensitive = true
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}
