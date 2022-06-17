provider "yandex" {
  folder_id = var.yc_folder_id
  zone = var.yc_zone
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    cores  = var.vm-1_cores
    memory = var.vm-1_memory
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
  name = "terraform2"

  resources {
    cores  = var.vm-2_cores
    memory = var.vm-2_memory

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
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
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
