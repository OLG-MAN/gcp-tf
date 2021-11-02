### Bucket for startup script and index.html

resource "google_storage_bucket" "tf-backend-gcs" {
  name          = "tf-backend-gcs"
  force_destroy = "true"
  location      = "US"
}