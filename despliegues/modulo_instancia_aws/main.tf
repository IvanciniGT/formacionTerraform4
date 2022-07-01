terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }

        null = {
            source = "hashicorp/null" 
        }
    }
}

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

resource "aws_key_pair" "clave_aws" {
  key_name   = "clave-tf-${var.nombreDespliegue}"
#  public_key = file( var.ficheroClaveSSHPublica )
  public_key = var.claveSSHPublica
}

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
    #private_key = file( var.ficheroClavePEMPrivada )
    private_key = var.clavePEMPrivada
  }
  
  provisioner "remote-exec" {
    inline = [ "echo HOLA DESDE AMAZON !!! soy tu nuevo servidor ;)" ]
  }
}