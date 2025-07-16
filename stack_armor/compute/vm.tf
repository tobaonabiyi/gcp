resource "google_compute_instance" "web_vm" {
  name         = "stack-armor-web-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
    }
  }
  network_interface {
    subnetwork = "stack-armor-subnet"
    access_config {} 
  }
  metadata_startup_script = file("${path.module}/scripts/startup.sh")
  service_account {
    email  = google_service_account.web_vm.email
    scopes = ["cloud-platform"]
  }
  tags = ["http-server"]
}

resource "google_service_account" "web_vm" {
  account_id   = "web-vm-sa"
  display_name = "Web VM Service Account"
}


resource "google_project_iam_member" "sa_gcs_permissions" {
  project = var.prj_id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.web_vm.email}"
}

resource "google_storage_bucket" "html_bucket" {
  name     = "${var.prj_id}-html-content"
  location = var.region
  uniform_bucket_level_access = true
}