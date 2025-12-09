output "vpn_external_ip" {
  value = google_compute_instance.vpn_1.network_interface[0].access_config[0].nat_ip
}

output "vpn_internal_ip" {
  value = google_compute_instance.vpn_1.network_interface[0].network_ip
}

output "ssh_command" {
  value = "ssh ${var.ssh_user}@${google_compute_instance.vpn_1.network_interface[0].access_config[0].nat_ip}"
}
