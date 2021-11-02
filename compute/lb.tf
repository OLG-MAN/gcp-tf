### Forwarding rule for lb
resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name       = "global-forwarding-rule"
  project    = var.project
  target     = google_compute_target_http_proxy.target_http_proxy.self_link
  port_range = "80"
}

### Used by one or more global forwarding rule to route incoming HTTP requests to a URL map
resource "google_compute_target_http_proxy" "target_http_proxy" {
  name    = "proxy"
  project = var.project
  url_map = google_compute_url_map.url_map.self_link
}

### URL map for LB
resource "google_compute_url_map" "url_map" {
  name            = "load-balancer"
  project         = var.project
  default_service = google_compute_backend_service.backend_service.self_link
}

### Backend sevice for lb
resource "google_compute_backend_service" "backend_service" {
  name                  = "backend-service"
  project               = var.project
  port_name             = "http"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = ["${google_compute_health_check.healthcheck.self_link}"]

  backend {
    group                 = google_compute_instance_group_manager.mig_group.instance_group
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }

  # security_policy = google_compute_security_policy.policy.self_link

}

### Healtcheck for backend service
resource "google_compute_health_check" "healthcheck" {
  name               = "healthcheck"
  timeout_sec        = 1
  check_interval_sec = 1
  http_health_check {
    port = 80
  }
}