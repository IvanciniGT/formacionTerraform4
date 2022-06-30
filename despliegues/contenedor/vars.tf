variable "container_name" {
    type        = string
    description = "Nombre del contenedor a crear en docker"
}

variable "ports" {
    type        = list(object({
        internal = number
        external = number
        protocol = string 
        ip       = string
    }))
    description = "Puertos a exponer en el host para el contenedor"
    validation  {
        condition = alltrue([ for puerto in var.ports: 
                                puerto.internal >=1 && puerto.internal <= 65535 ])
        error_message = "Los puertos del contenedor (internal) deben estar entre 1 y 65535"
    }
    validation  {
        condition = alltrue([ for puerto in var.ports: 
                                puerto.external >=1 && puerto.external <= 65535 ])
        error_message = "Los puertos del host (external) deben estar entre 1 y 65535"
    }
    validation  {
        #condition = alltrue([ for puerto in var.ports: 
        #                        puerto.protocol == "tcp" || puerto.protocol == "udp" ])
        condition = alltrue([ for puerto in var.ports: 
                                contains( ["tcp","udp"], puerto.protocol) ])
        error_message = "El protocolo debe ser tcp o udp"
    }
    validation  {
        condition = alltrue([ for puerto in var.ports: 
                                puerto.ip == null 
                                    || length(regexall("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)[.]){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
                                            , puerto.ip != null ? 
                                                puerto.ip : 
                                                "IP INVALIDA" ))
                                        ==1 ]
                                )
        error_message = "La IP no tiene un formato válido"
    }
    nullable = true # Parece que significa que pueden no darme un valor NOOO!!!!!
                    # Significa que me pueden asignar un volor nulo
    #default = 
}
variable "environment" {
    type        = map(string)  # Esta variable alberga un texto
    description = "Variables de entorno del contenedor"
    nullable    = true
}

variable "image" {
    type        = object({
        repo = string
        tag  = string
    })
    description = "Imagen de contenedor a descargar. Debe contener las claves 'repo' y 'tag'"
    
    validation {
        condition = var.image.repo != null && var.image.tag != null
        error_message = "Debe suministrar un valor no nulo para el repo y el tag de la imagen"
    }
}



variable "volumes" {
    type        = list(object({
        host_path       = string 
        container_path  = string
    }))
    description = "Volumenes locales a montar en el contenedor"
    validation  {
        condition = var.volumes ==null ? true : alltrue([ for volumen in var.volumes: 
            length(regexall("^[/]?([A-Za-z0-9_.-]+[/]?)*$"
                        , volumen.host_path != null ? 
                            volumen.host_path : 
                            "RUTA INVALIDA" ))
                    ==1 ]
                                )
        error_message = "La ruta del host para el volumen no es válida"
    }
    validation  {
        condition = var.volumes ==null ? true : alltrue([ for volumen in var.volumes: 
            length(regexall("^[/]?([A-Za-z0-9_.-]+[/]?)*$"
                        , volumen.container_path != null ? 
                            volumen.container_path : 
                            "RUTA INVALIDA" ))
                    ==1 ]
                                )
        error_message = "La ruta del contenedor para el volumen no es válida"
    }
    nullable = true
}


variable "resources" {
    type        = object({
        memory       = number # Es nullable y requerido sin opción a cambiarlo
        cpu_shares   = number
    })
    description = "Limitacion de recursos Hardware para el conteendor"
    
    validation {
                    # Si resources es nulo delvuelve que es valido
                    # si resources no es nulo 
                        #devuelve si la memoria es mayor que 0
        condition = ( var.resources==null 
                        ? true
                        : var.resources.memory == null 
                            ? true
                            : var.resources.memory > 0
                    )
        error_message = "El valor de memoria del contenedor debe ser positivo"
    }
    validation {
        condition = ( var.resources==null 
                        ? true
                        : var.resources.cpu_shares == null 
                            ? true
                            : var.resources.cpu_shares > 0
                    )
        error_message = "El valor de cpu_shares del contenedor debe ser positivo"
    }
    nullable = true
}

# Asegurarse que si hay cambio REAL en la imagen 
# (en el registry) que se actualice

variable "force_image_refresh" {
    type        = bool
    description = "Fuerza descarga de imagen si cambia en el registry"
    nullable = false
}