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
variable count_format { default = "%01d" }
variable count_offset { default = 0 }
