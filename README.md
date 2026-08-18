# Terraform KVM Basic

Simple Infrastructure as Code project using Terraform to create a Debian virtual machine on a local KVM/libvirt hypervisor.

## Stack

- Debian
- Terraform
- KVM / QEMU
- libvirt
- QCOW2

## Architecture

```text
Terraform
    │
    ▼
 libvirt
    │
    ▼
   KVM
    │
    ▼
Debian VM
```

## Prerequisites

Check that Terraform, KVM, QEMU and libvirt are installed:

```bash
terraform version
virsh version
qemu-system-x86_64 --version
ls -l /dev/kvm
systemctl status libvirtd
```

Check the default libvirt network:

```bash
virsh net-list --all
```

The `default` network must be active.

## Terraform commands

Initialize the project:

```bash
terraform init
```

Format the configuration:

```bash
terraform fmt
```

Validate the configuration:

```bash
terraform validate
```

Create an execution plan:

```bash
terraform plan
```

Create the VM:

```bash
terraform apply
```

Confirm with:

```text
yes
```

## Check the VM

List virtual machines:

```bash
virsh list --all
```

Start the VM manually if necessary:

```bash
virsh start terraform-basic-vm
```

Check running VMs:

```bash
virsh list
```

Display the VM configuration:

```bash
virsh dumpxml terraform-basic-vm
```

Check the disk:

```bash
virsh domblklist terraform-basic-vm
```

Check the network interface:

```bash
virsh domiflist terraform-basic-vm
```

## Terraform state

List managed resources:

```bash
terraform state list
```

Display the current state:

```bash
terraform show
```

Check for configuration changes:

```bash
terraform plan
```

Expected result when everything is synchronized:

```text
No changes. Your infrastructure matches the configuration.
```

## Destroy the VM

Remove the VM and its disk:

```bash
terraform destroy
```

Confirm with:

```text
yes
```

The infrastructure can then be recreated with:

```bash
terraform apply
```

## AppArmor

On this Debian host, libvirt's AppArmor configuration prevented QEMU from opening the VM disk.

For this local lab, the following configuration was required in `/etc/libvirt/qemu.conf`:

```text
security_driver = "none"
```

Then restart libvirt:

```bash
systemctl restart libvirtd
```

> Disabling the security driver is acceptable for this local lab but should not be considered a production configuration.

## Project goal

This project demonstrates a basic Terraform workflow for managing KVM/libvirt infrastructure:

```text
terraform init
      ↓
terraform validate
      ↓
terraform plan
      ↓
terraform apply
      ↓
    KVM VM
      ↓
terraform destroy
```
