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

variable "ipv4_addresses" {
  type        = list(string)
  description = "A list of IPv4 addresses to assign to the VM."
  default     = []
}
variable "ipv4_gateway" {
  type        = string
  description = "The IPv4 gateway to assign to the VM."
  default     = null
}

variable "ipv6_addresses" {
  type        = list(string)
  description = "A list of IPv6 addresses to assign to the VM."
  default     = []
}
variable "ipv6_gateway" {
  type        = string
  description = "The IPv6 gateway to assign to the VM."
  default     = null
}

variable "nameservers" {
  type        = list(string)
  description = "The DNS servers to assign to the VM."
  default     = []
}

variable "username" {
  type        = string
  description = "The username to set up within the VM."
  default     = "sncsuser"
}

variable "ssh_keys" {
  type        = list(string)
  description = "A list of public SSH keys to add to the authorized keys file of the user."
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

variable "ethernet_adapter" {
  type        = string
  description = "Ehternet adapater to which to apply network configuration"
  default     = "ens192"
}

variable "custom_userdata" {
  type        = string
  description = "Any custom data to include in the userdata.yml cloudinit manifest"
  default     = ""
}
