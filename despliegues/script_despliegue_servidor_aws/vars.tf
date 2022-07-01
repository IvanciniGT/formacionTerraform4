variable "ficherosClave" {
    type = object({
        privada       = string 
        publica       = string
    })
    description = "Ficheros donde guardar o pasar las claves"
    nullable = false
}

# Borrar claves on destroy

variable "borrarFicherosDeClavesAlDestruir" {
    type = bool
    description = "Borrar los ficheros de claves ssh al destruir la infraestructura"
    nullable = false
}

# Variable: Generar claves????? FALSE | TRUE

variable "generarNuevasClaves" {
    type = bool
    description = "Generar nuevas claves SSH para la infra"
    nullable = false
    default = true
}


variable "regionAWS" {

    type = string 
    
    description = "Region de amazon donde desplegar"
    
    validation {
        condition     = can(regex("^[a-z]{2}-[a-z]+-[1-9]$", var.regionAWS))
        error_message = "La región suministrada no es válida."
    }
    
    nullable = false
    
    default  = "eu-west-1"
}