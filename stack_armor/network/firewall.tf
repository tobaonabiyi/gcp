# Allow HTTP from LB only 
resource "google_compute_firewall" "allow_http_lb" {
  name    = "allow-http-from-lb"
  network = google_compute_network.vpc.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = [
    "130.211.0.0/22",  
    "35.191.0.0/16"
  ]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["http-server"]
}

# (Optional) Allow SSH only from your IP
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-from-admin"
  network = google_compute_network.vpc.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["99.49.83.183/32", "35.235.240.0/20"] 

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh-access"]
}

# Default egress: allow all
resource "google_compute_firewall" "allow-egress" {
  name    = "allow-egress"
  network = google_compute_network.vpc.name

  direction = "EGRESS"
  priority  = 1000

  destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }
}
