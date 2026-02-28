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

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "tobias-boyer-dev"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "hcloud_server" "web" {
  name        = "tobias-boyer-dev"
  image       = "ubuntu-24.04"
  server_type = "cx23"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.default.id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}
