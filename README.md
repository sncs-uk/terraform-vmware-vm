<!-- BEGIN_TF_DOCS -->
# VMware VM terraform module

This module creates a VM from a template, using cloud-init to customise the settings.
It abstracts all the data objects away so there is just one resource to configure.

Disk sizes are in GB

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vsphere"></a> [vsphere](#provider\_vsphere) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vsphere_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) | resource |
| [vsphere_compute_cluster.cluster](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/compute_cluster) | data source |
| [vsphere_datacenter.datacenter](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) | data source |
| [vsphere_datastore.datastore](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datastore) | data source |
| [vsphere_network.network](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/network) | data source |
| [vsphere_virtual_machine.template](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_disks"></a> [additional\_disks](#input\_additional\_disks) | List of additional disks to add to the VM. | <pre>list(object({<br/>    label            = string<br/>    size             = number<br/>    thin_provisioned = optional(bool, true)<br/>    eagerly_scrub    = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The vSphere Cluster on which the VM will be created. | `string` | n/a | yes |
| <a name="input_datacenter_name"></a> [datacenter\_name](#input\_datacenter\_name) | The name of the vSphere Datacenter to which the VM will be assigned. | `string` | n/a | yes |
| <a name="input_datastore_name"></a> [datastore\_name](#input\_datastore\_name) | The vSphere Datastore in which the VM's disks will be stored. | `string` | n/a | yes |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The size of the OS disk in GB. Must be a whole number. | `number` | `null` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | The hostname for the VM (doubles as the VM name). | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount of memory in MB to assign to the VM. | `number` | `2048` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Contents of the metadata.yaml cloudinit manifest | `string` | `""` | no |
| <a name="input_nameservers"></a> [nameservers](#input\_nameservers) | The DNS servers to assign to the VM. | `list(string)` | `[]` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network to which to connect the VM. | `string` | `"VM Network"` | no |
| <a name="input_talosconfig"></a> [talosconfig](#input\_talosconfig) | Contents of the talos config cloudinit manifest | `string` | `""` | no |
| <a name="input_template_name"></a> [template\_name](#input\_template\_name) | The name of the template to clone. | `string` | n/a | yes |
| <a name="input_thin_provision"></a> [thin\_provision](#input\_thin\_provision) | Whether the disk should be thin provisioned. | `bool` | `true` | no |
| <a name="input_userdata"></a> [userdata](#input\_userdata) | Contents of the userdata.yml cloudinit manifest | `string` | `""` | no |
| <a name="input_vCPUs"></a> [vCPUs](#input\_vCPUs) | The number of vCPUs to assign to the VM. | `number` | `2` | no |
| <a name="input_vm_folder"></a> [vm\_folder](#input\_vm\_folder) | The VM folder into which the the VM will be placed. | `string` | n/a | yes |
| <a name="input_wait_for_guest_ip_timeout"></a> [wait\_for\_guest\_ip\_timeout](#input\_wait\_for\_guest\_ip\_timeout) | Time to wait for guest IP to be marked as up | `number` | `0` | no |
| <a name="input_wait_for_guest_net_timeout"></a> [wait\_for\_guest\_net\_timeout](#input\_wait\_for\_guest\_net\_timeout) | Time to wait for guest network to be marked as up | `number` | `5` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm"></a> [vm](#output\_vm) | n/a |
<!-- END_TF_DOCS -->