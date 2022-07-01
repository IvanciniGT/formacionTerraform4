# Código

Codigo en linea, lo pongo entre `comillas` simples

Bloque de código

```tf

locals {
    #claveSSHPublica = file(var.ficherosClave.publica)
    claveSSHPublica = ( 
                        var.generarNuevasClaves 
                        ? module.claves_conexion[0].par_claves.public_key_openssh 
                        : file(var.ficherosClave.publica)
                        )
}

```


## Listas

### Listas de tareas

- [ ] Esto es una tarea inacabada
- [X] Esto es una tarea acabada

### Listas numeradas

1. item 1
2. item 2
   1. item 1
   2. item 2
   3. item 3
3. item 3

También:

1) Item 1
1) Item 2
1) Item 2

### Listas no numeradas

- Item 1
- Item 2
- Item 3
  - Item 1
  - Este item tiene dos párrafos
   
    Soy el segundo párrafod el item
  - Item 3

Se admiten también * + para las listas. Buena práctica es no mezclarlas

* Item 1
* Item 2

Y también:
+ item 1
+ item 2


Esto es una frase que estoy escribiendo.
Esto es otra frase que estoy escribiendo, pero en el mismo párrafo... De hecho md las juntará.

Esta frase ya iría en un nuevo párrafo.\
Esta frase la podría poner dentro del mismo párrafo, pero comenzando en la linea siguiente. Para ello podemos o bien acabar la linea anterior con 2 espacios en blanco (si bien no está considerado una buen práctica) o añadiendo una contrabarra en la linea anterior.




Varios saltos de linea, se toman como uno solo.


# Título de primer nivel

## Título de segundo nivel #################################################

### Encabezado de nivel 3
#### Encabezado de nivel 4
##### Encabezado de nivel 5
###### Puedo poner encabezados hasta de nivel 6
####### Este ya no sería un encabezado

Otra forma de poner un encabezado de nivel 1
===================================================================

Otra forma de poner un encabezado de nivel 2
-

Saltos de sección:

---

Esto sería una sección 

- - -

Y esto otra

* * *



## Estilos de textos

### Enfasis: 

Soy un texto *enfatizado*

### Enfásis mayor 

Soy un texto **enfatizado**

### Super enfásis

Soy un texto ***enfatizado***

Las extrellitas las podemos reemplazar por __guiones bajos__

Suele ser aceptado poner * en lugar de _

### Tachado 

~~Soy un texto tachado~~

