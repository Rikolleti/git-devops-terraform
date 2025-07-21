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
------
