module "bucket" {
  source = "./bucket"
}

module "compute" {
  source = "./compute"
}

module "cloudsql" {
  source = "./cloudsql"
}