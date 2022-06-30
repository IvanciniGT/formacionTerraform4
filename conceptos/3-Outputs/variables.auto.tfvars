programa          = "nginx"

version_programa  = "latest"

nombre_contenedor = "mi-nginx"

variables_contenedor = [
        "DATO1=valor1",
        "DATO2=valor2"
    ]
    
puertos_expuestos = [
        {
                interno = 80
                externo = 83
                protocolo = "tcp"
                ip = "0.0.0.0"
        },
        {
                interno = "443"
                externo = "443"
                protocolo = "tcp"
                ip = "172.31.10.35"
        }
]

