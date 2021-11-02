### Create a VPC
resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

### Create a ptrivate network
resource "google_compute_subnetwork" "sub-network" {
  name          = "private-subnetwork"
  ip_cidr_range = "10.10.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

### Create a public ip for nat service
resource "google_compute_address" "nat_ip" {
  name    = "nat-ip"
  project = var.project
  region  = var.region
}

### Create a nat to allow private instances connect to internet
resource "google_compute_router" "nat-router" {
  name    = "nat-router"
  network = google_compute_network.vpc_network.name
}

resource "google_compute_router_nat" "nat-gateway" {
  name                               = "nat-gateway"
  router                             = google_compute_router.nat-router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat_ip.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_compute_address.nat_ip]
}

### Firewall rules
resource "google_compute_firewall" "ssh-rule" {
  name    = "ssh-rule"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh"]
  source_ranges = ["109.87.152.248/32"]
}


resource "google_compute_firewall" "http-rule" {
  name    = "http-rule"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }

  target_tags = ["web"]
}