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
  source = "https://github.com/IvanciniGT/terraform_modulo_claves_ssh/releases/tag/v1"
  
  ficherosClave = var.ficherosClave
  borrarFicherosDeClavesAlDestruir = var.borrarFicherosDeClavesAlDestruir
}

# module.claves_conexion.private_key_openssh

