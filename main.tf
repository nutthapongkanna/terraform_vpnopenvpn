# -----------------------
# Network
# -----------------------
resource "google_compute_network" "vpc_main" {
  name                    = "vpc-main"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_main" {
  name          = "subnet-main"
  region        = var.region
  network       = google_compute_network.vpc_main.id
  ip_cidr_range = "10.10.0.0/24"
}

# -----------------------
# Firewall
# -----------------------
resource "google_compute_firewall" "allow_openvpn" {
  name    = "fw-openvpn-udp-1194"
  network = google_compute_network.vpc_main.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "udp"
    ports    = ["1194"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["vpn-server"]
}

resource "google_compute_firewall" "allow_ssh_vpn" {
  name    = "fw-vpn-ssh"
  network = google_compute_network.vpc_main.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_source_ranges
  target_tags   = ["vpn-server"]
}

resource "google_compute_firewall" "allow_from_vpn_clients" {
  name    = "fw-allow-from-vpn-clients"
  network = google_compute_network.vpc_main.name

  direction = "INGRESS"
  priority  = 1000

  allow { protocol = "icmp" }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["10.8.0.0/24"]
  target_tags   = ["vpn-client-target"]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "fw-allow-internal-10-10"
  network = google_compute_network.vpc_main.name

  direction = "INGRESS"
  priority  = 1000

  allow { protocol = "icmp" }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.10.0.0/24"]
}

# -----------------------
# VM: OpenVPN (Docker)
# -----------------------
resource "google_compute_instance" "vpn_1" {
  name         = "vpn-1"
  machine_type = "e2-small"
  zone         = var.zone
  tags         = ["vpn-server"]

  boot_disk {
    initialize_params {
      image = var.ubuntu_image
      size  = 20
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_main.id
    subnetwork = google_compute_subnetwork.subnet_main.id
    access_config {}
  }

  can_ip_forward = true

  metadata_startup_script = templatefile("${path.module}/startup.sh.tftpl", {
    openvpn_image = "${var.openvpn_image_repo}:${var.openvpn_image_tag}"
  })

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
