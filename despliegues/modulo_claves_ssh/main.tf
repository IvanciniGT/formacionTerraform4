terraform {
    required_providers {
       tls = {
            source = "hashicorp/tls"
            version = "3.4.0"
        }
        null = {
            source = "hashicorp/null" 
        }
    }
}


resource "tls_private_key" "mis_claves" {
    algorithm = "RSA"
    rsa_bits  = 4096
    
    #local-exec que grabe las claves a un fichero
    provisioner "local-exec" {
        command = "echo '${self.private_key_pem}' > ${var.ficherosClave.privada} && chmod 600 ${var.ficherosClave.privada}"
    }
    provisioner "local-exec" {
        command = "echo '${self.public_key_pem}' > ${var.ficherosClave.publica}  && chmod 644 ${var.ficherosClave.publica}"
    }
   
}


resource "null_resource" "borrador_de_claves" {
    triggers = {
    # Nos da relación de dependencia / ORDEN EN LA EJECUCION
    # Que solo se ejecuta si hay cambio en los contenedores
        mi_trigger = tls_private_key.mis_claves.id
        BORRAR = var.borrarFicherosDeClavesAlDestruir
        FICHERO_PUBLICA = var.ficherosClave.publica
        FICHERO_PRIVADA = var.ficherosClave.privada
    }
     provisioner "local-exec" {
        command = "${self.triggers.BORRAR} && rm ${self.triggers.FICHERO_PUBLICA} || exit 0"
        when = destroy
    }
     provisioner "local-exec" {
        command = "${self.triggers.BORRAR} && rm ${self.triggers.FICHERO_PRIVADA} || exit 0"
        when = destroy
    }
}
