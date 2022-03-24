variable "aws_access_key" {
  type        = string
  description = "aws access key for image import"
  default     = ""
}
variable "aws_secret_key" {
  type        = string
  description = "secret key corresponding to aws-access-key"
  default     = ""
  sensitive   = true
}
variable "ovafile" {
  type        = string
  description = "Defines OVA file to use as input"
  default     = "./artifacts/ova/rhel-vbox.ova"
}

source "virtualbox-ovf" "ovffile" {
  source_path      = "${var.ovafile}"
  ssh_username     = "packer"
  ssh_password     = "packer"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  format           = "ova"
}

build {

  sources = ["sources.virtualbox-ovf.ovffile"]

  provisioner "shell" {
    script          = "./post/prep-vm.sh"
    execute_command = "sudo -S sh -c '{{ .Vars }} {{.Path }}'"
  }

  # provisioner "file" {
  #   source      = "ifcfg-eth0"
  #   destination = "/etc/sysconfig/network-scripts/ifcfg-eth0"
  # }

  post-processor "amazon-import" {
    access_key          = var.aws_access_key
    secret_key          = var.aws_secret_key
    region              = "us-east-1"
    s3_bucket_name      = "tkolstee-packer-test"
    keep_input_artifact = true
  }

}