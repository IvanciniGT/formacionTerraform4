# Provider -> AWS
# Datos cuenta ??? Seguro !

# Qué hace ese provider?

Consola WEB                         ->    CLOUD AWS
Cliente de linea de comandos: aws


Provider de aws en terraform -> cli de aws -> CLOUD AWS




CLAVE
    Provisioner -> CREATE -> Ficheros       > script (fichero, variable si hay que borrar)
    
    Cambio el fichero de variables 
    
    Provisioner -> DESTROY -> Borrar los ficheros
                    no deja usar la palabra var.
                        No se ni que fichero hay que borrar
                            var.ficheroClaves