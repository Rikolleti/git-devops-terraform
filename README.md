# Домашнее задание к занятию «Введение в Terraform»

### Цели задания

1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.

------

### Чек-лист готовности к домашнему заданию

<img width="630" height="76" alt="Снимок экрана 2025-07-21 в 13 34 54" src="https://github.com/user-attachments/assets/327e2475-5bbc-47ba-aea9-f052829a30b8" />

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Репозиторий с ссылкой на зеркало для установки и настройки Terraform: [ссылка](https://github.com/netology-code/devops-materials).
2. Установка docker: [ссылка](https://docs.docker.com/engine/install/ubuntu/). 
------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1

1. Готово
2. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд) - personal.auto.tfvars
3. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение. - 
"result": "qIyJXd76x27uB6sb"
4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их. - 
Ошибки три: Error: Missing name for resource, Error: Invalid resource name и random_password.random_string_FAKE.resulT, исправил так:
Добавил имя к ресурсу resource "docker_image"
Исправил имя ресурса с 1nginx на nginx
Исправил ссылку на ресурс с random_password.random_string_FAKE.resulT на random_password.random_string.result

rikolleti@compute-vm-2-2-30-hdd-1751355561681:~/Netology/Terraform/src$ terraform validate
Success! The configuration is valid.

6. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.

Исправленный фрагмент кода:
```
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
provider "docker" {}

#однострочный комментарий

resource "random_password" "random_string" {
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

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }
}
```

<img width="1376" height="136" alt="Снимок экрана 2025-07-21 в 13 47 32" src="https://github.com/user-attachments/assets/b4a05978-0b86-4106-9312-ac5b107a9211" />


7. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды ```docker ps```.

Как я понимаю, тут просто не нужно подтверждать изменения, что может быть чревато тем, что если конфиг maint.tf будет некорректным, то изменения будут сделаны без доп.подтверждения со стороны пользователя.

Вывод docker ps:
```
rikolleti@compute-vm-2-2-30-hdd-1751355561681:~/Netology/Terraform/src$ docker ps
CONTAINER ID   IMAGE                                                COMMAND                  CREATED          STATUS          PORTS                  NAMES
c7b1d0a304c9   22bd15417453                                         "/docker-entrypoint.…"   14 seconds ago   Up 14 seconds   0.0.0.0:9090->80/tcp   hello_world
```

9. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**.:

Вывод terraform.tfstate:
```
rikolleti@compute-vm-2-2-30-hdd-1751355561681:~/Netology/Terraform/src$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.12.2",
  "serial": 23,
  "lineage": "960cc1a4-3a7b-5361-40ce-958da6170e31",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```
 
10. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ**, а затем **ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ** строчкой из документации [**terraform провайдера docker**](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs).  (ищите в классификаторе resource docker_image )

Это произошло из-за строчки keep_locally = true, которая сохраняет образ локально.
Из документации: "keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation.If this is false, it will delete the image from the docker local storage on destroy operation"

------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 2*

1. Создайте в облаке ВМ. Сделайте это через web-консоль, чтобы не слить по незнанию токен от облака в github(это тема следующей лекции). Если хотите - попробуйте сделать это через terraform, прочитав документацию yandex cloud. Используйте файл ```personal.auto.tfvars``` и гитигнор или иной, безопасный способ передачи токена! - Создал через web-консоль.
2. Подключитесь к ВМ по ssh и установите стек docker. - Готово
3. Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh:

provider "docker" {
  host     = "ssh://rikolleti@158.160.184.1:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}
(https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)
  
5. Используя terraform и  remote docker context, скачайте и запустите на вашей ВМ контейнер ```mysql:8``` на порту ```127.0.0.1:3306```, передайте ENV-переменные. Сгенерируйте разные пароли через random_password и передайте их в контейнер, используя интерполяцию из примера с nginx.(```name  = "example_${random_password.random_string.result}"```  , двойные кавычки и фигурные скобки обязательны!) 
```
    environment:
      - "MYSQL_ROOT_PASSWORD=${...}"
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - "MYSQL_PASSWORD=${...}"
      - MYSQL_ROOT_HOST="%"
```
Готово:

```
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
```

6. Зайдите на вашу ВМ , подключитесь к контейнеру и проверьте наличие секретных env-переменных с помощью команды ```env```. Запишите ваш финальный код в репозиторий. - Готово

### Задание 3*
1. Установите [opentofu](https://opentofu.org/)(fork terraform с лицензией Mozilla Public License, version 2.0) любой версии
2. Попробуйте выполнить тот же код с помощью ```tofu apply```, а не terraform apply.

Готово:
```
rikolleti@compute-vm-2-2-30-hdd-1751355561681:~/Netology/Terraform/OpenTofu$ tofu apply

OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

OpenTofu will perform the following actions:

  # docker_container.mysql will be created
  + resource "docker_container" "mysql" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (sensitive value)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + must_run                                    = true
      + name                                        = (sensitive value)
      + network_data                                = (known after apply)
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + healthcheck (known after apply)

      + labels (known after apply)

      + ports {
          + external = 3306
          + internal = 3306
          + ip       = "127.0.0.1"
          + protocol = "tcp"
        }
    }

  # docker_container.nginx will be created
  + resource "docker_container" "nginx" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (known after apply)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + must_run                                    = true
      + name                                        = "hello_world"
      + network_data                                = (known after apply)
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + healthcheck (known after apply)

      + labels (known after apply)

      + ports {
          + external = 9090
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

  # docker_image.mysql will be created
  + resource "docker_image" "mysql" {
      + id           = (known after apply)
      + image_id     = (known after apply)
      + keep_locally = true
      + name         = "mysql:8"
      + repo_digest  = (known after apply)
    }

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" {
      + id           = (known after apply)
      + image_id     = (known after apply)
      + keep_locally = true
      + name         = "nginx:latest"
      + repo_digest  = (known after apply)
    }

  # random_password.mysql_pass will be created
  + resource "random_password" "mysql_pass" {
      + bcrypt_hash = (sensitive value)
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 1
      + min_numeric = 1
      + min_special = 0
      + min_upper   = 1
      + number      = true
      + numeric     = true
      + result      = (sensitive value)
      + special     = false
      + upper       = true
    }

  # random_password.mysql_root_pass will be created
  + resource "random_password" "mysql_root_pass" {
      + bcrypt_hash = (sensitive value)
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 1
      + min_numeric = 1
      + min_special = 0
      + min_upper   = 1
      + number      = true
      + numeric     = true
      + result      = (sensitive value)
      + special     = false
      + upper       = true
    }

  # random_password.random_string will be created
  + resource "random_password" "random_string" {
      + bcrypt_hash = (sensitive value)
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 1
      + min_numeric = 1
      + min_special = 0
      + min_upper   = 1
      + number      = true
      + numeric     = true
      + result      = (sensitive value)
      + special     = false
      + upper       = true
    }

Plan: 7 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  OpenTofu will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

docker_image.mysql: Creating...
docker_image.nginx: Creating...
docker_image.mysql: Creation complete after 0s [id=sha256:a0f6c7786c75739bd76a37b4b85e0f47b7c5d5a17a094bdd522412fb464d5cbemysql:8]
docker_image.nginx: Creation complete after 0s [id=sha256:22bd1541745359072c06a72a23f4f6c52dbb685424e0d5b29008ae4eb2683698nginx:latest]
docker_container.nginx: Creating...
random_password.mysql_pass: Creating...
random_password.mysql_root_pass: Creating...
random_password.random_string: Creating...
random_password.mysql_pass: Creation complete after 0s [id=none]
random_password.mysql_root_pass: Creation complete after 0s [id=none]
random_password.random_string: Creation complete after 0s [id=none]
docker_container.mysql: Creating...
docker_container.nginx: Creation complete after 0s [id=dbd77459e5480d5e05f1f8b0b5012066581b0b1cfaa2adcb3d18a6343cf782c3]
docker_container.mysql: Creation complete after 1s [id=c59e524c4fd858a62b629cd3ccf4caf51f387e0cfb696fe43567b646bd5d6d11]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
```

------
