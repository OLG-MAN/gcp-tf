### Bucket for startup script and index.html
resource "google_storage_bucket" "startup-bucket101" {
  name          = "startup-bucket101"
  force_destroy = "true"
  location      = "US"
}

### Copy startup script and index.html to bucket 
resource "google_storage_bucket_object" "startup-script" {
  name   = "startup.sh"
  source = "./bucket/startup.sh"
  bucket = "startup-bucket101"

  depends_on = [google_storage_bucket.startup-bucket101]

}

resource "google_storage_bucket_object" "index-page" {
  name   = "index.html"
  source = "./bucket/index.html"
  bucket = "startup-bucket101"

  depends_on = [google_storage_bucket.startup-bucket101]
}

### Add permission for service account
resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.startup-bucket101.name
  role = "roles/storage.admin"
  member = "serviceAccount:terraform@tf-gcp-325511.iam.gserviceaccount.com"
}
