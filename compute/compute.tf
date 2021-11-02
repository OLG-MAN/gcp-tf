### VM instance template
resource "google_compute_instance_template" "web_server" {
  name         = "terraform-instance"
  machine_type = "e2-medium"
  tags         = ["web", "ssh"]

  disk {
    source_image = "debian-cloud/debian-10"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.sub-network.self_link
  }

  metadata = {
    startup-script-url = "gs://startup-bucket101/startup.sh"
  }

  service_account {
    email  = "terraform@tf-gcp-325511.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

### Create a MIG
resource "google_compute_instance_group_manager" "mig_group" {
  name               = "mig-group"
  project            = var.project
  base_instance_name = "web-servers"
  zone               = var.zone
  version {
    instance_template = google_compute_instance_template.web_server.self_link
  }
  named_port {
    name = "http"
    port = 80
  }
}

### Autoscaler for MIG
resource "google_compute_autoscaler" "autoscaler" {
  name    = "autoscaler"
  project = var.project
  zone    = var.zone
  target  = google_compute_instance_group_manager.mig_group.self_link

  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}