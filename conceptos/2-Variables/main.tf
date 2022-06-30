terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

provider "docker" {
}

resource "docker_container" "mi_contenedor" {
    #name  = "${var.nombre_contenedor}"
    name  = var.nombre_contenedor
    image = docker_image.mi_imagen.latest 
    env = var.variables_contenedor
    
    #ports {
    #    internal = 80
    #    external = 83
    #    ip       = "127.0.0.1"
    #    protocol = "tcp"
    #}
    dynamic "ports" {
        for_each = var.puertos_expuestos # Aqui una lista
        iterator = puerto
        content {
            internal = tonumber(puerto.value["interno"])
            # La conversión de tipo de datos se hace 
            # automaticamente  por terraform si quiero
            external = puerto.value["externo"]
            protocol = puerto.value["protocolo"]
            ip       = puerto.value["ip"]
        }
    }
}
    

resource "docker_image" "mi_imagen" {
    #name = var.imagen                              # OPCION 1
    name = "${var.programa}:${var.version_programa}"               # OPCION 2
            # Interpolación de textos   
}
