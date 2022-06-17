variable "yc_zone" {
  description = "yandex cloud zone"
  type = string
  default = "ru-central1-a"
}

variable "yc_folder_id"{
  description = "folder_id"
  type = string
  default = "b1guu4qkcnpm0mu1up6r"
}
##################################
variable "vm-1_cores" {
  description = "cores for vm1"
  type = number
  default = 2
}

variable "vm-1_memory" {
  description = "memory for vm1"
  type = number
  default = 2
}
##################################
variable "vm-2_cores" {
  description = "cores for vm2"
  type = number
  default = 4
}

variable "vm-2_memory" {
  description = "memory for vm1"
  type = number
  default = 4
}
##################################
variable "image_id" {
  description = "image id"
  type = string
  default = "fd87tirk5i8vitv9uuo1"
}

variable "subnet_1" {
  description = "subnet"
  type = tuple([string])
  default = (["192.168.10.0/24"])
}
