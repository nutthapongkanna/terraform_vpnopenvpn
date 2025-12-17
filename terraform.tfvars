# --- Core ---
project_id = ""
region     = "asia-southeast1"
zone       = "asia-southeast1-a"

# --- SSH ---
ssh_source_ranges = ["0.0.0.0/0"]
ssh_user          = ""

# --- Ubuntu image ---
ubuntu_image = "ubuntu-os-cloud/ubuntu-2204-lts"

# --- OpenVPN docker image ---
openvpn_image_repo = "kylemanna/openvpn"
openvpn_image_tag  = "latest"
