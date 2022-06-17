provider "yandex" {
  folder_id = var.yc_folder_id
  zone = var.yc_zone
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform-${format(var.count_format, var.count_offset+count.index+1)}"
  count = local.inst_count[terraform.workspace]

  resources {
    cores  = local.vm-1_cores[terraform.workspace]
    memory = local.vm-1_memory[terraform.workspace]
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  metadata = {
    ssh-key = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-2" {
  for_each = local.instances
  name = each.key
  allow_stopping_for_update = true
  resources {
    cores  = each.value
    memory = each.value
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  metadata = {
    ssh-key = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
  lifecycle {
    create_before_destroy = true
   }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = var.subnet_1
}

locals {
  vm-1_cores = {
    stage = 2
    prod = 4
  }
  vm-1_memory = {
    stage = 2
    prod = 4
  }
  inst_count = {
    stage = 1
    prod = 2
  }
  instances = {
    "instance-1" = 2
    "instance-2" = 4
  }
}
