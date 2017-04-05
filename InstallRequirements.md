# Configurar Proxy para Docker

1. Creamos un directorio drop-in systemd para el servicio docker

		sudo mkdir /etc/systemd/system/docker.service.d

1. Crear un archivo llamado [ /etc/systemd/system/docker.service.d/http-proxy.conf ] en el que agregamos la variable HTTP_PROXY

		sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf

	Agregar:

        [Service]
        Environment="HTTP_PROXY=http://10.20.4.15:3128/"

1. Actualizar cambios:

		sudo systemctl daemon-reload

1. Verificar que la configuración fue cargada

    	systemctl show --property=Environment docker

	Saldra esto:

    	Environment=HTTP_PROXY=http://proxy.example.com:80/

1. Reiniciar Docker

		sudo systemctl restart docker


# Instalación Docker en CentOS

1. Actualizamos el sistemas

		sudo yum update -y

1. Agregamos el repo

        $ sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
        [dockerrepo]
        name=Docker Repository
        baseurl=https://yum.dockerproject.org/repo/main/centos/7/
        enabled=1
        gpgcheck=1
        gpgkey=https://yum.dockerproject.org/gpg
        EOF

1. Instalamos el Pakete Docker

		sudo yum install docker-engine

1. Habilitar el Servicio

		sudo systemctl enable docker.service

1. Iniciamos el sistemas

		sudo systemctl start docker

1. Verificar la Instalacion de Docker Corriendo un Imagen de test en un Container.

        sudo docker run --rm hello-world

	Saldrá lo Siguientes:

        Unable to find image 'hello-world:latest' locally
        latest: Pulling from library/hello-world
        c04b14da8d14: Pull complete
        Digest: sha256:0256e8a36e2070f7bf2d0b0763dbabdd67798512411de4cdcf9431a1feb60fd9
        Status: Downloaded newer image for hello-world:latest

        Hello from Docker!
        This message shows that your installation appears to be working correctly.

        To generate this message, Docker took the following steps:
        1. The Docker client contacted the Docker daemon.
        2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
        3. The Docker daemon created a new container from that image which runs the
         executable that produces the output you are currently reading.
        4. The Docker daemon streamed that output to the Docker client, which sent it
         to your terminal.

        To try something more ambitious, you can run an Ubuntu container with:
        $ docker run -it ubuntu bash

        Share images, automate workflows, and more with a free Docker Hub account:
        https://hub.docker.com

        For more examples and ideas, visit:
        https://docs.docker.com/engine/userguide/


## Crear Grupo Docker

1. Creamos grupo

		sudo groupadd docker

1. Agregamos Usuario a Grupo Docker

		sudo usermod -aG docker your_username

1. Cerrar Sesion del usuario o reinicie el equipo:

		sudo init 6

1.  Verificar que el usuario esta en el grupo Docker

		docker run --rm hello-world


# Installar Docker Compose

correr:

	sudo -i

Descargamos Paquete:

    curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

Aplicamos Permisos de Ejecución:

	chmod +x /usr/local/bin/docker-compose

Comprobamos la Instalacion:

	docker-compose --version

Obtendremos Algo como esto:

	docker-compose version: 1.9.0


## Fuentes:

[Proxy para Docker](https://docs.docker.com/engine/admin/systemd/)

[Instalacion Docker](https://docs.docker.com/engine/installation/linux/centos/)

[Instalacion Docker Compose](https://docs.docker.com/compose/install/#/alternative-install-options)


