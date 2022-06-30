terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
        tls = {
            source = "hashicorp/tls"
            version = "3.4.0"
        }
        null = {
            source = "hashicorp/null" 
        }
    }
}

provider "aws" {
    region = var.regionAWS
}
provider "tls" {
  # Configuration options
}
provider "null" {
  # Configuration options
}
# Crear una maquina Linux
# Para conectar con ssh:
# Cutre: contraseña
# Seria: claves ******* Publica/Privada

resource "tls_private_key" "mis_claves" {
    algorithm = "RSA"
    rsa_bits  = 4096
    
  #local-exec que grabe las claves a un fichero
    provisioner "local-exec" {
        command = "echo '${self.private_key_pem}' > ${var.ficherosClave.privada}"
    }
    provisioner "local-exec" {
        command = "echo '${self.public_key_pem}' > ${var.ficherosClave.publica}"
    }
   
}


resource "null_resource" "ejecutor" {
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

resource "aws_key_pair" "clave_aws" {
  key_name   = "clave-tf-ivan"
  public_key = tls_private_key.mis_claves.public_key_openssh
}
