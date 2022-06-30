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

data "aws_ec2_instance_type" "comprobacion_tipo_instancia" {
  instance_type = var.tipoInstancia
}


resource "null_resource" "comprobador" {
    triggers = {
      trigger = data.aws_ec2_instance_type.comprobacion_tipo_instancia.id
    
    }
     provisioner "local-exec" {
      command =  "echo La instancia es: ${data.aws_ec2_instance_type.comprobacion_tipo_instancia.id}" 
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
        command = "echo '${self.public_key_pem}' > ${var.ficherosClave.publica}  && chmod 600 ${var.ficherosClave.publica}"
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
  ami             = data.aws_ami.imagen_so.id
  instance_type   = data.aws_ec2_instance_type.comprobacion_tipo_instancia.id
  security_groups = [ aws_security_group.mi_security_group.name ]
                      # Nos da relación de dependencia / ORDEN EN LA EJECUCION
  key_name        =  aws_key_pair.clave_aws.id
  
#  PROBLEMON !!!! NO HACER JAMAS EN LA VIDA BAJO RIESGO DE MUTILACION 
  #  security_groups = [ "securitygroup-tf-${var.nombreDespliegue}" ] # Esto funciona? MALAMENTE !!
  # AQUI NO HAY RELACION DE DEPENDENCIA
  
  tags = {
    Name = "instancia-tf-${var.nombreDespliegue}"
  }
  
}

resource "null_resource" "probador" {
  count = var.probarConexion ? 1 : 0
  
  triggers = {
      trigger = aws_instance.maquina.public_ip
  }
    
  connection {
    host = aws_instance.maquina.public_ip
    type = "ssh"
    port = 22
    user = "ubuntu"
    private_key = tls_private_key.mis_claves.private_key_pem
  }
  
  provisioner "remote-exec" {
    inline = [ "echo HOLA DESDE AMAZON !!! soy tu nuevo servidor ;)" ]
  }
}