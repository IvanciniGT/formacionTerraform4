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
  key_name   = "clave-tf-${var.nombreDespliegue}"
  public_key = tls_private_key.mis_claves.public_key_openssh
}


# Generar un security group que:
# Entrante: 22 y 80
# Saliente a todos los sitios

resource "aws_security_group" "mi_security_group" {
  name        = "securitygroup-tf-${var.nombreDespliegue}"
  vpc_id      = null

  ingress {
    description      = "Aceptar ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  ingress {
    description      = "Aceptar http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }
  
  ingress {
    description      = "Aceptar https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "securitygroup-tf-${var.nombreDespliegue}"
  }
}


data "aws_ami" "imagen_so" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = [ "*ubuntu-xenial-16.04-amd64-server-*" ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



resource "aws_instance" "maquina" {
  ami           = "ami-01963b791a3b02b6d"
  instance_type = "t2.micro"

  tags = {
    Name = "PruebaTF_Ivan" #instancia-tf-NOMBRE
  }
  
  #securityGroup
  #Clave
}
