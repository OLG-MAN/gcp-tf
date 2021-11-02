variable "project" {
  default = "tf-gcp-325511"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}

variable "min_replicas" {
  type        = string
  description = "Min number of VMs for autoscale"
  default     = "2"
}

variable "max_replicas" {
  type        = string
  description = "Max number of VMs for autoscale"
  default     = "4"
}