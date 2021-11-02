### Secutiry policy (Cloud Armor)

# resource "google_compute_security_policy" "policy" {
#   name        = "armor-security-policy"
#   description = "example security policy"

#   ### Block access from some North Korea ip's
#   rule {
#     action   = "deny(403)"
#     priority = "1000"
#     match {
#       versioned_expr = "SRC_IPS_V1"
#       config {
#         src_ip_ranges = ["57.73.214.0/24"]
#       }
#     }
#     description = "Deny access to IPs in 57.73.214.0/24"
#   }
  
#   ### Default rule
#   rule {
#     action   = "allow"
#     priority = "2147483647"
#     match {
#       versioned_expr = "SRC_IPS_V1"
#       config {
#         src_ip_ranges = ["*"]
#       }
#     }
#     description = "default rule"
#   }
# }