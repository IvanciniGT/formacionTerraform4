# Sintaxis HCL

# Con el cuadradito ponemos comentarios

# Vamos definiendo bloques:
#       - terraform: Daremos información general sobre terraform:
#                   - versión de terraform mínima requerida para procesar este fichero
#                   - los proveedores que vamos a usar
#       - provider NOMBRE 
#                   Ese nombre es un nombre interno, lo elijo yo
#                   Aquí ponemos la configuración del proveedor
#       - resource TIPO NOMBRE
#                   TIPO, lo define el proveedor. Lo miro en la documentación del provider
#                   NOMBRE, lo defino yo. El que yo quiera... es un nombre interno a este fichero
#                           con el que referirme al recurso.
#                           No tiene nada que ver con el nombre que el recurso tendrá en el proveedor

terraform {
    # Proveedores que necesitamos para este script
    required_providers {
        docker = {
            source = "kreuzwerker/docker" # Esta libreria se va a buscar por 
                                          # parte de terraform en el terraform registry
                                          # En ocasiones podremos poner aqui otras cosas...
        }
    }
}

# Aqui pondríamos configuración requerida por el proveedor concreto
provider "docker" {
    # En el caso de docker, no necesitamos de mucha cosa... 
    # de hecho de nada a priori
}

# Quiero definir un contenedor basado en esa imagen
resource "docker_container" "mi_contenedor" {
    name  = "mi_apache"
    image = docker_image.mi_imagen.latest # Nos decuelve el ID de la imagen
}

# Empezamos a definir / declarar los recursos / servicios que quiero en ese proveedor
# Quiero asegurarme que en el proveedor que uso (según config anterior) quede 
# una imagen de contenedor

resource "docker_image" "mi_imagen" {
    name = "httpd:alpine3.16"
}

# La referencia entre recursos marca el orden de ejecución