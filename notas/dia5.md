# Permisos en linux

# Damos permisos de 3 tipòs, para 3 tipos de personas:

Tipos de permisos:
    R   Read
    W   Write
    X   Execution
    
Tipos de personas:
    O Owner - Propietario
    G Group - Grupo 
    Other - Resto del mundo
    
Permisos de un archivo:

   Grupo
   ---
RWXRWXRWX
---   *** Otros
Propietario

Para poner el usuario propietario de un archivo: 
$ chown USUARIO:GRUPO archivo

Para poner los permisos:
$ chmod ### archivo

Primer numero -> propietario
Segundo numero -> grupo
Tercer numero -> otros

Para cada uno de ellos:

RWX
000
111

0 Carace de ese permiso
1 Tiene el permiso

100   Lectura           4
010   Escritura         2
001   Ejecución         1

4 -> Lectura
5 -> Lectura y ejecución
6 -> Lectura y Escritura
7 -> Todos los permisos

Clave publica:
644
Propietario: Leer y escribir el fichero
Grupo y otros -> Leerla

Clave privada:
600
Propietario: Leer y escribir el fichero
Grupo y otros -> NADA !!!!


Script
    - configurar el proveedor de amazon

    Modulo que crea claves
        Variables de entrada
            fichero
            Si los borra
        Datos de salida
            clave
        
    Modulo que crea instancia
        Variables de entrada
            claves
        Datos de salida


El modulo que crea la instancia en AWS
    - Verificar imagen
    - Crea un security group
    - Da de alta la clave publica en AWS
    - Crea la instancia
        - Security group
        - clave publica
    - Prueba la conexión ?????? Opcionalmente
        - Clave privada      ?? Opcionalmente
        
        
Bloques de primer nivel en terraform:
- terraform
- provider
- resources
- data
- variable
- output
- locals
    Locals permite definir variables internas al programa


Crear unos recursos
    Y si estan bien
    Tengo que esperar a que unos programas dentro de un servidor se arranquen
Creo otros

Servidor 1 - Cree ... y esta operativo? 
    Imagen que lleva unos programas ya instaaldos
    
    bash... sleep 
Servidor 2.... esperar al servidor 1
