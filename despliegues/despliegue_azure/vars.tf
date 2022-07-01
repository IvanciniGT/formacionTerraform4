// Vais a definir las variable OBVIAS que creais

variable "nombre_grupo_recursos" {
    type = string
    description ="Nombre del grupo de recursos PREEXISTENTE"
    default  = null
}

variable "ip_publica" {
    type = string
    description ="Si deseas generar una ip publica (si|no)"
    default  = "si"
    validation {
        error_message = "Solo puede poner 'si' o 'no'."
        condition = var.ip_publica == "si" || var.ip_publica == "no"
    }    
}

/*
nombre_grupo_recursos <- default null
    Si no me pasan la variable quiero crear un grupo de recursos
    con un nombre aleatorio: grupo-recursos-(5 caracteres aleatorios)
    Si me pasan un nombre uso ese
---> output
nombre_red_virtual
---> output
nombre_subred
---> output
contraseña, no la pido... la genero ALEATORIA... dato sensible
---> output (sensitive = true)
public_ip = si | no*
    validar el valor de la variable
    */