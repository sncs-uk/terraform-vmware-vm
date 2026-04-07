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

  wait_for_guest_net_timeout = var.wait_for_guest_net_timeout
  wait_for_guest_ip_timeout  = var.wait_for_guest_ip_timeout

  extra_config = {
    "guestinfo.userdata"          = var.userdata == "" ? "" : base64gzip(var.userdata)
    "guestinfo.userdata.encoding" = var.userdata == "" ? "" : "gzip+base64"
    "guestinfo.metadata"          = var.metadata == "" ? "" : base64gzip(var.metadata)
    "guestinfo.metadata.encoding" = var.metadata == "" ? "" : "gzip+base64"
    "guestinfo.talos.config"      = base64encode(var.talosconfig)
  }

  # Customization of the VM #
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = "false"
  }

  # Ignore changes to the guestinfo, as it can cause re-creation where there shoulldn't be
  lifecycle {
    ignore_changes = [
      extra_config
    ]
  }
}

