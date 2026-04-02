/**
 * # VMware VM terraform module
 *
 * This module creates a VM from a template, using cloud-init to customise the settings.
 * It abstracts all the data objects away so there is just one resource to configure.
 *
 * Disk sizes are in GB
 */

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter_name
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.hostname
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  # VM resources #
  num_cpus = var.vCPUs
  memory   = var.memory

  # Guest OS #
  guest_id = data.vsphere_virtual_machine.template.guest_id
  firmware = data.vsphere_virtual_machine.template.firmware
  folder   = var.vm_folder

  # VM storage #
  disk {
    label            = "OS.vmdk"
    size             = var.disk_size == null ? data.vsphere_virtual_machine.template.disks[0].size : var.disk_size
    thin_provisioned = var.thin_provision
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
  }

  dynamic "disk" {
    for_each = var.additional_disks
    content {
      label            = disk.value["label"]
      size             = disk.value["size"]
      thin_provisioned = disk.value["thin_provisioned"]
      eagerly_scrub    = disk.value["eagerly_scrub"]
      unit_number      = disk.key + 1
    }
  }

  # VM networking #
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  extra_config = {
    "guestinfo.userdata" = base64gzip(
      templatefile(
        "${path.module}/templates/userdata.yaml.tmpl",
        {
          username        = var.username,
          ssh_keys        = var.ssh_keys,
          custom_userdata = var.custom_userdata
        }
      )
    )
    "guestinfo.userdata.encoding" = "gzip+base64"
    "guestinfo.metadata" = base64gzip(
      templatefile(
        "${path.module}/templates/metadata.yaml.tmpl",
        {
          hostname    = var.hostname,
          nic_name    = var.ethernet_adapter
          dhcp4       = length(var.ipv4_addresses) == 0,
          dhcp6       = length(var.ipv6_addresses) == 0,
          addresses   = concat(var.ipv4_addresses, var.ipv6_addresses)
          gateway4    = var.ipv4_gateway
          gateway6    = var.ipv6_gateway
          nameservers = var.nameservers
        }
      )
    )
    "guestinfo.metadata.encoding" = "gzip+base64"
  }

  # Customization of the VM #
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = "false"
  }
}
