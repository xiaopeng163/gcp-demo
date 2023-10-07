provider "google" {
  project = "xxxxxxxxxx"
}

resource "google_compute_instance" "default" {
  count = 1

  name         = "test-${count.index}"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    # read cloud init script from file
    startup-script = file("start.sh")
  }

  #metadata_startup_script =  file("start.sh")

}

# Output the public IP addresses for each instance
output "public_ips" {
  value = google_compute_instance.default.*.network_interface.0.access_config.0.nat_ip
}


# firewall rule to allow http traffic
resource "google_compute_firewall" "default" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["12555"]
  }

  source_ranges = [ "0.0.0.0/0" ]
}