# Declarar el provider
# Pero no configuro la autenticacion (se hace en el cli de aws-que nosotros ya tenemos configurado)

# Qué permite Cloud9?
# Entornos de desarrollo + maquina (computador)

# Al crear un entorno que necesitabamos?
# Region Irlanda > En AWS previamente

# Nombre
# Tipo de instancia t2.micro
# SO

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

#resource "aws_cloud9_environment_ec2" "example" {
#  instance_type = "t2.micro"
#  name          = "EntornoPruebaIvan"
#  image_id      = "ubuntu-18.04-x86_64"
#}




resource "aws_instance" "maquina" {
  ami           = "ami-01963b791a3b02b6d"
  instance_type = "t2.micro"

  tags = {
    Name = "PruebaTF_Ivan"
  }
}