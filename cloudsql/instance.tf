### Create My SQL database instance
resource "google_sql_database_instance" "my_sql" {
  name             = "mysql-db105"
  project          = var.project
  region           = var.region
  database_version = var.db_version
  deletion_protection = false

  settings {
    tier              = var.db_tier
    activation_policy = var.db_activation_policy
    disk_autoresize   = var.db_disk_autoresize
    disk_size         = var.db_disk_size
    disk_type         = var.db_disk_type
    pricing_plan      = var.db_pricing_plan

    location_preference {
      zone = var.zone
    }

    maintenance_window {
      day  = "7" # sunday
      hour = "3" # 3am  
    }

    database_flags {
      name  = "log_bin_trust_function_creators"
      value = "on"
    }

    backup_configuration {
      binary_log_enabled = true
      enabled            = true
      start_time         = "00:00"
    }

    ip_configuration {
      ipv4_enabled = "true"
      authorized_networks {
        value = var.db_instance_access_cidr
      }
    }
  }
}

### Create database
resource "google_sql_database" "my_sql_db" {
  name      = var.db_name
  project   = var.project
  instance  = google_sql_database_instance.my_sql.name
  charset   = var.db_charset
  collation = var.db_collation
}

### Generate db password
resource "random_id" "user_password" {
  byte_length = 8
}

### Create User
resource "google_sql_user" "my-sql" {
  name     = var.db_user_name
  project  = var.project
  instance = google_sql_database_instance.my_sql.name
  host     = var.db_user_host
  password = google_secret_manager_secret_version.database-password.secret_data

  depends_on = [
    google_secret_manager_secret_version.database-password,
  ]
}

### Create a secret for db instacnce
resource "google_secret_manager_secret" "database-password" {
  secret_id = "database-password"
  replication {
    automatic = true
  }
}

### Add secret data for db instance
resource "google_secret_manager_secret_version" "database-password" {
  secret = google_secret_manager_secret.database-password.id
  secret_data = random_id.user_password.hex
}
