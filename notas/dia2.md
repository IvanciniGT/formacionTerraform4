# Terraform

Automatizar trabajos contra un proveedor, usando el lenguaje HCL (declarativo).

Ficheros .tf :
- terraform < configuración de terraform y declaración de providers
- provider  < configuración del provider
- resource  
- variable  < parametrización

- data      < busquedas y extracción de infromación en el provider
- output    < extraer información de los resources recien creados

El proyecto completo es una carpeta en terraform:
- main.tf < con la declaración de proveedores y recursos
- vars.tf < no necesariamente se tiene que llamar así pero por convenio se usa ese nombre (variables)
- XXXXX.auto.tfvars < Damos valores por defecto a las variables
- XXXXX.tfvars      < Valores específicos para un despliegue

Estos ficheros los procesamos con el comando terraform:
- init      < Descarga de los providers
- validate  < Valida los ficheros de terraform
- plan      < Calcula los cambios y operaciones que hay que hacer en la infra real
    --var CLAVE=VALOR           MEJOR OLVIDARNOS DE EL 
    --var-file FICHERO.tfvars
- apply     < Aplica el plan y genera la infra (o la cambia)
- destroy   < Liquida la infra
 
Las variables tienen su tipo:
- string                "valor"
- set(string)           [ "valor1", "valor2" ]          Se entiende que el orden de los datos no es relevante
- list(string)          [ "valor1", "valor2" ]


Jenkins
    Montar un contenedor de docker -> desde una imagen que contenga terraform
    Dentro del contenedor clono el repo de mi despliegue de terraform
    Terraform init
    Terraform apply 
    Terraform output > fichero de inventario
    Tiro ese contenedor terraform a la basura
    monto un contenedor con ansible
    Le clono el repo del playbook que este usando
    ansible-playbook -i GENERADO_ADHOC PLAYBOOK
    El contenedor de ansible a la basura



# Providers

Una libreria para poder gestionar servicios que ofrezca un PROVEEDOR DE SERVICIOS

# Provisioner

Una libreria que nos permite ejecutar comandos/realizar acciones contra un recurso/servicio

Hay 3 provisioners en Terraform:
    local-exec      Ejecutar un comando localmente
    remote-exec     Ejecutar un comando en el recurso remoto
    file            Copiar ficheros del local al remoto
    ---
    chef                |
    puppet              |   No me importa no tener ansible
    habitat             |   Aunque lo tuviera no lo usaria
    salt-masterless     |   JAMAS EN LA VIDA
    ANSIBLE NO          |   NUNCA, Ni los de puppet & company los uso
    
* local, localmente: donde estamos ejecutando terraform

Estoy montando una solución FUERTEMENTE ACOPLADA !!!

Orquestador: JENKINS & company
