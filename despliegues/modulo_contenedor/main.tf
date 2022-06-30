terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

data "docker_registry_image" "imagen_en_registry" {
    name = "${var.image.repo}:${var.image.tag}"
}

resource "docker_image" "mi_imagen" {
    name          = "${var.image.repo}:${var.image.tag}"
    pull_triggers = (
                        var.force_image_refresh
                        ? [ data.docker_registry_image.imagen_en_registry.sha256_digest ]
                        : null
                    )
           # nginx:latest
}

resource "docker_container" "mi_contenedor" {
    
    name  = var.container_name
    image = docker_image.mi_imagen.latest 
    
        # Set of String     environment => map(strings)
    env = var.environment == null ? null : [ for clave, valor in var.environment: "${clave}=${valor}" ]
    
    dynamic "ports" {
        for_each = var.ports == null ? [] : var.ports
        iterator = puerto
        content {
            internal = puerto.value["internal"]
            external = puerto.value["external"]
            protocol = puerto.value["protocol"]
            ip       = puerto.value["ip"]
        }
    }
    dynamic "volumes" {
        for_each = var.volumes == null ? [] : var.volumes
        iterator = volumen
        content {
            host_path      = volumen.value["host_path"]
            container_path = volumen.value["container_path"]
        }
    }
    # cpu_shares  = null                        # Si var.resources es nulo
    # cpu_shares  = var.resources.cpu_shares    # Si var.resources no es nulo
    cpu_shares  = (
                    var.resources == null # Si es nulo: recursos
                        ? null            # Devuelvo null. Es como si no hubiera definido cpu_shares
                        : var.resources.cpu_shares
                    )
    
    memory  = var.resources == null ? null : var.resources.memory
            # CONDICION ? ValoreSiSeCumple: ValorSiNoSecumple       # Operador ternario
            # Python        ValoreSiSeCumple if CONDICION else ValorSiNoSecumple
    
    memory_swap = -1
}