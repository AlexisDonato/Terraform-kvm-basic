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


# Create a Debian virtual machine on KVM/libvirt.
resource "libvirt_domain" "debian_vm" {
  # Name of the virtual machine.
  name = "terraform-basic-vm"

  # Use KVM as the hypervisor.
  type = "kvm"

  # Allocate 1 GB of RAM and 1 virtual CPU.
  memory = 1024
  vcpu   = 1

  # Will start automatically with the host
  autostart = true

  # Define the type of virtualized operating system.
  os = {
    type = "hvm"
  }

  # Define the devices attached to the virtual machine.
  devices = {
    # Attach the Terraform-managed Debian disk.
    disks = [
      {
        source = {
          volume = {
            pool   = "default"
            volume = libvirt_volume.debian_disk.name
          }
        }

        # Present the disk to the VM as /dev/vda using VirtIO.
        target = {
          bus = "virtio"
          dev = "vda"
        }
      }
    ]

    # Connect the VM to libvirt's default network.
    interfaces = [
      {
        source = {
          network = {
            network = "default"
          }
        }
      }
    ]
  }
}
