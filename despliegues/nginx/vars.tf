variable "contenedor" {
    type        = string
    description = "Nombre del contenedor a crear en docker"
}

variable "image" {
    type        = object({
        repo = string
        tag  = string
    })
    description = "Imagen de contenedor a descargar. Debe contener las claves 'repo' y 'tag'"
}

variable "external_port" {
    type        = number
    description = "Puerto publico del nginx"
}
