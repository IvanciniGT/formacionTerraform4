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

module "nginx" {
    
    source = "../modulo_contenedor"
    
    container_name = var.contenedor
    image = var.image
    
    ports = [
        {
            internal = 80
            external = var.external_port
            protocol = "tcp"
            ip       = "0.0.0.0"
        }
    ]
    
}

resource "null_resource" "ejecutor" {
    triggers = {
        mi_trigger = module.nginx.id
                     # Relacion de dependencia
                     # Al haber un cambio en este dato, 
                     #      el resource se ejecuta y por tanto su provisioner
    }
    provisioner "local-exec" {
        command = "echo ${module.nginx.direccion_ip}"
    }
}



        