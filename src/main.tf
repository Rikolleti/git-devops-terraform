terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = ">=1.8.4" /*Многострочный комментарий.
 Требуемая версия terraform */
}

provider "docker" {
  host     = "ssh://rikolleti@158.160.184.1"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

#однострочный комментарий

resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "mysql_root_pass" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "mysql_pass" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name = "hello_world"
  // name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name = "example_${random_password.random_string.result}"
  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_pass.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_pass.result}",
    "MYSQL_ROOT_HOST=%"
  ]

  ports {
    ip = "127.0.0.1"
    internal = 3306
    external = 3306
 }
}
