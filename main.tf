# Terraform configuration
# Define the libvirt provider used to manage our KVM infrastructure.
terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.9.8"
    }
  }
}

# Connect Terraform to the system libvirt instance.
provider "libvirt" {
  uri = "qemu:///system"
}

# Create a libvirt volume from an existing Debian cloud image.
# The volume will be stored in libvirt's "default" storage pool.
resource "libvirt_volume" "debian_disk" {
  name = "terraform-basic-disk.qcow2"
  pool = "default"

  # Define the disk format.
  target = {
    format = {
      type = "qcow2"
    }
  }

  # Use the existing Debian image as the source for the new volume.
  create = {
    content = {
      url = "/root/devops-lab/images/debian-13-generic-amd64.qcow2"
    }
  }
}
