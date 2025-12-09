variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-southeast1"
}

variable "zone" {
  type    = string
  default = "asia-southeast1-a"
}

variable "ssh_source_ranges" {
  type        = list(string)
  description = "Public IP ranges allowed to SSH into vpn-1."
  default     = ["0.0.0.0/0"]
}

variable "ssh_user" {
  type        = string
  description = "Linux username used for SSH command output."
  default     = "your-linux-user"
}

# ✅ เปลี่ยนเป็น Ubuntu
variable "ubuntu_image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "openvpn_image_repo" {
  type    = string
  default = "kylemanna/openvpn"
}

variable "openvpn_image_tag" {
  type    = string
  default = "latest"
}
