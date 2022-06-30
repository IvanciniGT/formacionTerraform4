variable "numero_de_instancias" {
    type        = number
    description = "Numero de contenedores a generar"
    default     =  3
}

variable "contenedores_a_crear" {
    type        = map(number)
    description = "Numero de contenedores a generar"
    default     =  {
        contenedor1 = 8090
        contenedorB = 9097
    }
}

# Quiero poder poner nombres arbitrarios, 
# pero quiero poder indicar para cada contenedor:
# Puerto inter y el puerto externo

variable "contenedores_a_crear_mas_personalizados" {
    type        = map(map(number))
    description = "Numero de contenedores a generar"
    default     =  {
        contenedor_personalizado_1 = {
            interno = 80
            externo = 8091
        }
        contenedor_personalizado_B = {
            interno = 80
            externo = 9091
        }
    }
}

variable "comandos" {
    type        = map(list(string))
    description = "Comandos de los contenedores a generar"
    default     =  {
        contenedor_personalizado_1 =  ["sh" ,"-c",  "sleep 3600"]
        contenedor_personalizado_B =  ["sh" ,"-c",  "sleep 7200"]
    }
}

variable "contenedores_como_lista" {
    type        = list( map(string)  )
    description = "Contenedores a generar"
    default     =  [
        {
            nombre = "contenedor_lista_1"
            interno = 80
            externo = 8092
        },
        {
            nombre = "contenedor_lista2_B"
            interno = 80
            externo = 9092
        }
    ]
}