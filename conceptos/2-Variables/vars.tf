variable "puertos_expuestos" {
    type        = list(map(string))
    description = "Puertos a exponer en el host para el contenedor"
}

variable "variables_contenedor" {
    type        = set(string)  # Esta variable alberga un texto
    description = "Variables de entorno del contenedor"
    #default     = [
    #    "DATO1=valor1",
    #    "DATO2=valor2"
    #]
}


variable "nombre_contenedor" {
    type        = string  # Esta variable alberga un texto
    description = "Nombre del contenedor a crear en docker"
    #default     = "httpd" # Este es opcional
}
# OPCION 2
# A este variable me referiré con el texto: var.programa
variable "programa" {
    type        = string  # Esta variable alberga un texto
    description = "Nombre del repo de la imagen de contenedor a descargar"
    #default     = "httpd" # Este es opcional
}
# A este variable me referiré con el texto: var.version
variable "version_programa" {
    type        = string  # Esta variable alberga un texto
    description = "Tag de la imagen de contenedor a descargar"
    #default     = "2.4.54-alpine3.16" # Este es opcional
}

# OPCION 1: A este variable me referiré con el texto: var.imagen
#variable "imagen" {
#    type        = string  # Esta variable alberga un texto
#    description = "Nombre del repo y tag de la imagen de contenedor a descargar"
#    default     = "httpd:2.4.54-alpine3.16" # Este es opcional
#}