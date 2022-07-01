
variable "claveSSHPublica" {
    type = string
    description = "La clave publica en formato SSH-RSA"
    nullable = false
}

variable "clavePEMPrivada" {
    type = string
    description = "La clave publica en formato PEM"
    nullable = true
    default = null
}

#variable "ficheroClaveSSHPublica" {
#    type = string
#    description = "Fichero con la clave publica en formato SSH-RSA"
#    nullable = false
#    
#    validation  {
#        condition = length(
#                        regexall("^[/]?([A-Za-z0-9_.-]+[/]?)*[.]rsa$",
#                                 var.ficheroClaveSSHPublica )
#                    ) == 1 
#        error_message = "La ruta del host para la clave publica ssh no es válida"
#    }
#}
#
#variable "ficheroClavePEMPrivada" {
#    type = string
#    description = "Fichero con la clave privada en formato PEM"
#    nullable = true
#    default = null
#    
#    validation  {
#        condition = var.ficheroClavePEMPrivada == null ? true :
#                    length(
#                        regexall("^[/]?([A-Za-z0-9_.-]+[/]?)*[.]pem$",
#                                 var.ficheroClavePEMPrivada )
#                    ) == 1 
#        error_message = "La ruta del host para la clave private ssh no es válida"
#    }
#    sensitive = true
#}

variable "nombreDespliegue" {
    type = string
    description = "Nombre que se añade a los recursos de amazon"
    nullable = false
    default = false
}

variable "tipoInstancia" {
    type = string
    description = "Tipo de instancia a crear"
    nullable = false
    default =  "t2.micro"
    
    validation {
        condition     = can(regex("^[a-z0-9]{2,}[.][a-z]+$", var.tipoInstancia))
        error_message = "El tipo de instancia no es válido."
    }
}


variable "probarConexion" {
    type = bool
    description = "Hace una prueba de conexion con la maquina"
    nullable = false
    default = true
}

locals {
    # CHAPUZA !!!!!! YA que terraform no permite referenciar a una variable desde otra en el bloque VARIABLE
    validacion_clave_ssh_en_funcion_de_prueba_conexion = (var.probarConexion 
                                ? (var.clavePEMPrivada == null
                                    ? tobool("No me has pasado la clave SSH Pringao!!!") # Esto corta el pragrama
                                    : true # "FEDERICO"
                                    )
                                :  (var.clavePEMPrivada != null
                                    ? tobool("Me has pasado la clave SSH y no estas pidiento una prueba de conexión, más Pringao!!!") # Esto corta el pragrama
                                    : true # "FEDERICO"
                                    )
                                )

}