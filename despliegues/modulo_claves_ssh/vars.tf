
variable "ficherosClave" {

    type = object({
        privada       = string 
        publica       = string
    })
    
    description = "Ficheros donde guardar las claves"
    
    validation  {
        condition = length(
                        regexall("^[/]?([A-Za-z0-9_.-]+[/]?)*[.]pem$",
                                 var.ficherosClave.privada )
                    ) == 1 
        error_message = "La ruta del host para la clave privada no es válida"
    }
    
    validation  {
        condition = length(
                        regexall("^[/]?([A-Za-z0-9_.-]+[/]?)*[.]pem$",
                                 var.ficherosClave.publica )
                    ) == 1 
        error_message = "La ruta del host para la clave publica no es válida"
    }
    
    nullable = false
    
    default  = {
        privada = "clave-privada.pem"
        publica = "clave-publica.pem"
    }
    
}

# Borrar claves on destroy

variable "borrarFicherosDeClavesAlDestruir" {
    type = bool
    description = "Borrar los ficheros de claves ssh al destruir la infraestructura"
    nullable = false
    default = false
}