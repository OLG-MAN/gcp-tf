### Show external ip address of load balancer
output "load-balancer-ip-address" {
  value = google_compute_global_forwarding_rule.global_forwarding_rule.ip_address
}

### Show nat ip address
output "nat_ip_address" {
  value = google_compute_address.nat_ip.address
}