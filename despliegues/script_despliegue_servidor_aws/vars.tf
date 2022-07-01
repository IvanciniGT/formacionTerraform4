variable "ficherosClave" {
    type = object({
        privada       = string 
        publica       = string
    })
    description = "Ficheros donde guardar las claves"
    nullable = false
}

# Borrar claves on destroy

variable "borrarFicherosDeClavesAlDestruir" {
    type = bool
    description = "Borrar los ficheros de claves ssh al destruir la infraestructura"
    nullable = false
}