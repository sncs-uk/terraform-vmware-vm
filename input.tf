variable "hostname" {
  type        = string
  description = "The hostname for the VM (doubles as the VM name)."
}

variable "template_name" {
  type        = string
  description = "The name of the template to clone."
}

variable "network_name" {
  type        = string
  description = "The name of the network to which to connect the VM."
  default     = "VM Network"
}

variable "nameservers" {
  type        = list(string)
  description = "The DNS servers to assign to the VM."
  default     = []
}

variable "vCPUs" {
  type        = number
  description = "The number of vCPUs to assign to the VM."
  default     = 2
}

variable "memory" {
  type        = number
  description = "The amount of memory in MB to assign to the VM."
  default     = 2048
}

variable "datacenter_name" {
  type        = string
  description = "The name of the vSphere Datacenter to which the VM will be assigned."
}
variable "cluster_name" {
  type        = string
  description = "The vSphere Cluster on which the VM will be created."
}
variable "datastore_name" {
  type        = string
  description = "The vSphere Datastore in which the VM's disks will be stored."
}
variable "vm_folder" {
  type        = string
  description = "The VM folder into which the the VM will be placed."
}
variable "disk_size" {
  type        = number
  description = "The size of the OS disk in GB. Must be a whole number."
  default     = null
}

variable "thin_provision" {
  type        = bool
  description = "Whether the disk should be thin provisioned."
  default     = true
}

variable "additional_disks" {
  type = list(object({
    label            = string
    size             = number
    thin_provisioned = optional(bool, true)
    eagerly_scrub    = optional(bool, false)
  }))
  description = "List of additional disks to add to the VM."
  default     = []
}

variable "userdata" {
  type        = string
  description = "Contents of the userdata.yml cloudinit manifest"
  default     = ""
}
variable "metadata" {
  type        = string
  description = "Contents of the metadata.yaml cloudinit manifest"
  default     = ""
}
variable "talosconfig" {
  type        = string
  description = "Contents of the talos config cloudinit manifest"
  default     = ""
}
