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

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "tobias-boyer-dev"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "hcloud_firewall" "web-firewall" {
  name = "tobias-boyer-dev-firewall"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
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
  firewall_ids = [hcloud_firewall.web-firewall.id]
}
