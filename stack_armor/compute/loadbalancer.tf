resource "google_compute_global_address" "lb_ip" {
  name = "stack-armor-web-lb-ip"
}

resource "google_compute_health_check" "http_health_check" {
  name               = "stack-armor-web-health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 3

  http_health_check {
    port = 80
    request_path = "/"
  }
}

resource "google_compute_instance_group" "web_instance_group" {
  name        = "web-instance-group"
  zone        = var.zone
  instances   = [google_compute_instance.web_vm.self_link]
  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_backend_service" "web_backend" {
  name                            = "web-backend-service"
  port_name                       = "http"
  protocol                        = "HTTP"
  load_balancing_scheme           = "EXTERNAL"
  timeout_sec                     = 10
  health_checks                   = [google_compute_health_check.http_health_check.self_link]
  backend {
    group = google_compute_instance_group.web_instance_group.self_link
  }
}

resource "google_compute_url_map" "web_url_map" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.web_backend.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name   = "web-http-proxy"
  url_map = google_compute_url_map.web_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name        = "web-http-forwarding-rule"
  ip_address  = google_compute_global_address.lb_ip.address
  port_range  = "80"
  target      = google_compute_target_http_proxy.http_proxy.self_link
  load_balancing_scheme = "EXTERNAL"
}