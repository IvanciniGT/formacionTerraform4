
terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker" 
        }
        null = {
            source = "hashicorp/null" 
        }
    }
}

provider "docker" {
}
provider "null" {
}

resource "docker_container" "mi_contenedor" {
    name  = "mi_apache"
    image = docker_image.mi_imagen.latest 
    
    
    # En ansible lo hariamos con el module: shell
    # delegate_to: localhost
    provisioner "local-exec" {
    # Este se ejecuta cuando creamos el objeto o se modifica
        command = "./crear_inventario.sh"
        #
        environment = {
            IP_MAQUINA = docker_container.mi_contenedor.ip_address
            DIRECTORIO = "/home/ubuntu/environment"
        }
    }
    provisioner "local-exec" {
    # Este se ejecuta cuando borramos el objeto
        command = "rm inventario.ini"
        working_dir = "/home/ubuntu/environment"
        when    = destroy
    }
}



resource "docker_container" "mi_contenedor_multiple" {
    count = 3
    name  = "mi_apache_${count.index}"
    image = docker_image.mi_imagen.latest 
}

resource "null_resource" "ejecutor" {
    triggers = {
    # Nos da relación de dependencia / ORDEN EN LA EJECUCION
    # Que solo se ejecuta si hay cambio en los contenedores
        mi_trigger = join( " ", docker_container.mi_contenedor_multiple.*.ip_address )
    }
    provisioner "local-exec" {
        command = "echo HOLA"
    }
}





resource "docker_container" "mi_contenedor_con_ejecucion_remota" {
    name  = "mi_ssh_container"
    image = docker_image.mi_imagen.latest 

    # Conectarme primero con el entorno remoto
    # IP
    # usuario
    # password / credenciales
    # puerto
    # metodo de conexion: ssh | winrm
    connection {
        user        =   "root"
        password    =   "root"
        type        =   "ssh"
        port        =   22
        host        =   self.ip_address
    }
    provisioner "remote-exec" {
        inline = [
                    "echo Hola desde el contenedor!!!",
                    "echo Yo también te saludo desde el contenedor"
                ]

    }
    provisioner "remote-exec" {
        script = "mi_script.sh" # Copia y ejecuta un script
    }
    provisioner "remote-exec" {
        scripts = ["mi_script.sh"]
    }

    provisioner "file" {
        source      = "./configuracion.conf"
        destination = "/tmp/miconfiguracion.txt"
    }

    provisioner "file" {
        content     = "Aqui pongo el contenido: ${self.ip_address}"
        destination = "/tmp/miconfiguracion2.txt"
    }

    
}




resource "docker_image" "mi_imagen" {
    name = "rastasheep/ubuntu-sshd:latest"
}
