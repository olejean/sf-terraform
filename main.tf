
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }



  backend "s3" { # тип используемого хранилища
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "sf-terraforn-storage-file" # имя хранилища
    key                         = "issue1/terraform.tfstate"  # путь до state-файла в хранилище
    region                      = "ru-central1"               # регион размещения хранилища
    access_key                  = "YCAJEgLiwAo5VQa3yHm8wOyrR"
    secret_key                  = "YCNN7wzEO-pGKBu9Xv2u4xZp54C_2rMtzxiBzb57"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = "$YC_TOKEN"
  cloud_id  = "$YC_CLOUD_ID"
  folder_id = "$YC_FOLDER_ID"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "swarm-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}



module "swarm_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 2
}





