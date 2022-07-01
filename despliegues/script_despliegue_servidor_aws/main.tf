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

module "claves_conexion" {
  count = var.generarNuevasClaves ? 1 : 0
  source = "git::https://github.com/IvanciniGT/terraform_modulo_claves_ssh.git?ref=v1"
  
  ficherosClave = var.ficherosClave
  borrarFicherosDeClavesAlDestruir = var.borrarFicherosDeClavesAlDestruir
}

locals {
    #claveSSHPublica = file(var.ficherosClave.publica)
    claveSSHPublica = ( 
                        var.generarNuevasClaves 
                        ? module.claves_conexion[0].par_claves.public_key_openssh 
                        : file(var.ficherosClave.publica)
                        )
}

module "instancia" {
  source = "git::https://github.com/IvanciniGT/terraform_modulo_instancia_aws.git?ref=v3"
  
  #claveSSHPublica = file(var.ficherosClave.publica)
  #claveSSHPublica = ( 
  #                      var.generarNuevasClaves 
  #                      ? module.claves_conexion.par_claves.public_key_openssh 
  #                      : file(var.ficherosClave.publica)
  #                  )
  claveSSHPublica = local.claveSSHPublica
  # mas cosas de configuración
  nombreDespliegue = "Ivancete"
  probarConexion = false

  # Esto me asegura que el modulo de abajo se ejecute despues del modulo de arriba
  depends_on = [ # Tanto en modulos como en resources, solo si no hay una variable
               # digna que me permita crear la dependia autoamtica
      module.claves_conexion
  ]
}
