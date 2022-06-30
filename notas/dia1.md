# Terraform?

Software creado por Hashicorp.

Gestionar de forma automatizada servicios que nos puede ofrecer un proveedor de servicios:
 √ Infraestructura como código en un cloud.
 ~ Sistema para modelar (crear/borrar/mantener) equipos (maquinas virtuales)
 
 Para máquinas virtuales -> VAGRANT 

# Cloud

Conjunto de servicios (IT) que una empresa provee de forma automatizada a través de internet:

- infraestructura IaaS      Maquinas, Balanceadores, Redes, Almacenamiento
- plataforma PaaS           Kubernetes, BBDD
- software SaaS             Cloud9

# Proveedores de servicios IT

- Kubernetes:   Despligue de una app (contenedores), BC
- Docker:       Ejecuta un contenedor 
- Comando:      Quiero un par de claves publica/privada

# Automatizado 

Configurando/Creando un programa que adquirirá / borrará, modificará unos servicios -> Script

Ese script lo vamos a crear usando el lenguaje HCL ~ JSON, YAML
Terraform es quien procesará los ficheros que creemos con ese lenguaje

# Por qué otro lenguaje?

Paradigma que se usa en el lenguaje (Manera de expresar conceptos en ese lenguaje):
- Lenguaje imperativo
- Lenguaje procedural
- Lenguaje funcional
- Lenguaje orientado a objetos

Scripts: bash, ps1, python: Imperativo (procedural):
- Lenguaje imperativo: Dar ordenes:             Pon esa silla debajo de la ventana.

Lenguaje HCL:
- Lenguaje declarativo (Ansible, Kubernetes):   La silla debe estar debajo de la ventana.
- Da igual el estado inicial de lo que sea que configure, 
  que siempre tiene que quedar de la misma forma: IDEMPOTENCIA

Utilizamos el mismo lenguaje en todos los proveedores:

- Si yo defino una infraestructura (3 servidores, red, BC). Eso lo puedo pedir a cualquier cloud?
     Ni de coña
Si quiero pedir cosas a Azure, necesitaré un script....
Si quiero pedir las mismas cosas a AWS, necesitaré otro script.... TOTALMENTE distinto

# Conceptos / Términos de Terraform:

# Grámatica del lenguaje HCL:

PROVIDER: Software(libreria) que contacta con alguien que provee servicios.
          Dentro de ese provider, tendremos:

- RESOURCES: Servicios que podemos gestionar con un proveedor
    - Gestionar una instancia  
- DATA:      Búsqueda y captura de información de los recursos que ofrece un proveedor
    - Buscar imágenes de SO para montar en una instancia
- VARIABLE:  Parametrizar la infra / servicios
- OUTPUT:    Obtener información de vuelta de los servicios gestionados en un proveedor
- PROVISIONER (ansible) MUY POBRE < No lo usamos mucho (ANSIBLE)
    - Copiar ficheros al remoto
    - Ejecutar comandos BASH/SHELL en local (donde ejecuto terraform)
    - Ejecutar comandos en el remoto

# Terraform: PROGRAMA

Todos los ficheros que creemos de terraform, tendrán la extensión .tf
Además, todos deben estar en una misma carpeta < Proyecto

Usaremos el comando terraform, con distintas opciones:
- init      < Descargará los providers que se necesiten para ese proyecto (carpeta)
- validate  < Validar la sintaxis de los ficheros .tf
- plan      < Nos prepara un listado de las tareas que TERRAFORM hará para conseguir 
              que los servicios que deseamos queden en el proveedor en el estado que deseamos
- apply     < Aplica un plan para conseguir ^^^^^
- destroy   < Elimina los recursos / servicios del proveedor
- refresh   < Nosotros con el apply, gestionamos recursos en el proveedor...
              Nada impide que otro programa / persona (manazas) toque cosas por 
              su lado en el proveedor

# Los primeros ejemplos:

Los vamos a hacer usando como provider DOCKER

Docker es una herrameinta de contenedorización. Nos permite gestionar contenedores.

# Contenedor

Un contendor es un entorno aislado dentro de un SO con kernel linux donde ejecutar procesos.
Aislado:
- Tiene su propio sistema de archivos < chroot
- Tiene su propia configuración de red -> Su propia IP
- Limitación de acceso a los recursos HW del host
- Sus propias variables de entorno

En una forma de instaalr, distribuir y ejecutar aplicaciones

Los contenedores los creamos desde imágenes de contenedor.

Imagen de contenedor: Un triste fichero comprimido (tar) que contiene una(s) aplicaciones 
ya instaladas junto con las librerias y configuraciones necesarias para su funcionamiento

Son una alternativa a las Maquinas virtuales, para reolver muchos de los problemas que 
tenemos con las instalaciones a hierro.

Nos ofrecen una forma estandarizada de distribuir, ejecutar y operar software.


hierro < SO X < app1 + app2
Problemas: app1 y app2 pueden requerir librerias (dependencias) incompatibles
Problemas: app1 y app2 pueden requerir configuraciones diferentes de SO
Problemas: Si app1 tiene un bug y se vuelve loca (100% CPU)... app1 se jode... app2 también se jode


App1     | App2 + App3
-------------------
C 1.    |.  C 2
-------------------
gestor de contenedores: Docker, podman, [crio, containerd]
-------------------
SO linux®
-------------------
Hierro


# kubernetes (k8s, k3s, openshift)

gestores de gestores de contenedores

SO Linux: Cualquier SO que use el Kernel de SO llamado Linux

GNU/Linux: RHEL (centos, feroda, oracle unbreakeable linux), debian (ubuntu), suse
Android que no es un SO GNU/Linux, usa el kernel de Linux.
Linux es el Kernel de SO más usado del mundo.

Windows tiene su su kernel: DOS > kernel NT

Docker desktop for Windows      > Montar un MV hyperV (wsl) que corre un kernel de linux
Docker desktop for MacOS        > Montar un MV 


# Quiero instalar MySQL en mi ordenador a hierro... que hago?

1. Descargar el instalador de MySQL
2. Ejecuto el instalador 
3. Configuro la instalación          > La carpeta resultante en un ZIP y os la mando

Eso es una imagen de contenedor: Esa instalación que ha hecho alguien que sabe un huevo 
de esa herramienta empaquetada, junto con sus dependencias.

Esas imágenes se guardan/distribuyen a través de un registry de repos de imagenes de contenedor,
como:
- docker hub
- quay.io       REDHAT

Cuando trabajo con contenedores tengo solo 1 kernel, el del host...que es la base del SO.
Que pongo encima de un kernel:
- shell

Que shell tengo en ubuntu: sh, bash  , bsh, zsh, fish
Que shell tengo en centos: sh, bash  , bsh, zsh, fish
Si quiero crear una carpeta: mkdir 
Si quiero instalar apps dentro de un ubuntu: apt > debian
si quiero instalar apps dentro de un centos: yum


main.td
    2 servidores de tipo A
    1 servidor de tipo B

Apply

main.td
    1 servidores de tipo A
    0 servidor de tipo B
    3 servidor de tipo C
    
Apply 
    Borrar un servidor A
    Borrar un servidor B
    Crear 3 C
    

# Infraestructura como código
# Servicios como código

Código puede tener versiones: 
    Los servicios que adquiero puede tener versiones
    La infraestructura puede tener versiones 
    
Todo el código lo tengo en un SCM -> git
    Como estoy haciendo código. 
    
Yo que siempre he sido un SysAdmin... 
    entre otras cosas por que el código me da alergia
Ahora soy un programador
    Crear infraestructura < Terraform < Hacer un programa en tf < Sysadmin
    
Parametrizar los programas, para facilitar su mantenimiento.