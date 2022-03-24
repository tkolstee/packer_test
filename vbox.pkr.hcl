variable "ks_variant" {
  type        = string
  description = "Defines kickstart file to use"
  default     = "minimal"
}
variable "vol_size_mb" {
  type        = number
  description = "Size of primary disk in megabytes"
  default     = 30720
}
source "virtualbox-iso" "rhel8-ks" {
  guest_os_type    = "RedHat_64"
  iso_url          = "./rhel-8.2-x86_64-dvd.iso"
  iso_checksum     = "md5:76bb4125eeb0c0b1dc3ecf0c96339c6a"
  ssh_username     = "packer"
  ssh_password     = "packer"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  firmware         = "efi"
  disk_size        = var.vol_size_mb
  http_directory   = "./kickstarts"
  cpus             = 1
  memory           = 1024
  usb              = false
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--firmware", "EFI"],
  ]
  boot_command = [
    "<up>e",
    "<down><down><end>",
    " biosdevname=0 net.ifnames=0 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks-${var.ks_variant}.cfg",
    "<leftCtrlOn>x<leftCtrlOff>"
  ]
  # boot_keygroup_interval = "2s"
  boot_wait        = "6s"
  iso_interface    = "sata"
  ssh_timeout      = "45m"
  export_opts      = [ "--manifest", "--options", "nomacs" ]
  format           = "ova"
  output_directory = "./artifacts/ova"
  output_filename  = "rhel-vbox"
}
build {
  name    = "vbox"
  sources = ["sources.virtualbox-iso.rhel8-ks"]
}