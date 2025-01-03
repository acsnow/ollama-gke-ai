# Configure the Google Cloud provider
provider "google" {
  project = "tfc-sip-01"
  region  = "us-west1"
  zone = "us-west1-a"
}

# Create the GKE cluster
resource "google_container_cluster" "demo_openai_01" {
  name     = "demo-openai-01"
  location = "us-west1-a"
  deletion_protection = false
  remove_default_node_pool = true

  # We can define additional properties such as node pools, networking, etc.
  initial_node_count = 1
  node_config {
    machine_type = "n2-standard-8"

    # Configure the OAuth scopes to allow the nodes to access Google Cloud services
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  network = "primary-vault-vpc"
  subnetwork = "primary-subnet-01"

  # Enable some addons for the cluster
  addons_config {
    http_load_balancing        { disabled = false }
    horizontal_pod_autoscaling { disabled = false }
    gcp_filestore_csi_driver_config   { enabled = true }
  }
}

# Configure CPU node pool
resource google_container_node_pool "demo-openai-cpu-01" {
  name       = "demo-openai-cpu-01"
  cluster    = google_container_cluster.demo_openai_01.id
  node_count = 3
  node_config {
    preemptible  = false
    machine_type = "n2-standard-8"
  }
}



# Configure GPU node pool
resource google_container_node_pool "demo_openai_gpu_01" {
  name       = "demo-openai-gpu-01"
  cluster    = google_container_cluster.demo_openai_01.id
  node_count = 3
  node_config {
    preemptible  = false
    machine_type = "g2-standard-16"
    guest_accelerator {
      type  = "nvidia-l4"
      count = 1
      gpu_driver_installation_config {
        gpu_driver_version = "DEFAULT"
      }
    }
  }
}
