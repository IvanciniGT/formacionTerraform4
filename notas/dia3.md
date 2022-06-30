Condicionales en terraform


if var.variable 

si var.variable es true, o si no es un boolean, si es distinto de null, entra



VAR tag = null

var.tag ? var.tag : "latest"

Si no hay comparador... y la variable no es booleana:
    Si la variable esta asignada, se considera TRUE
    Si la variable no está asignada se considera FALSE
    
    
force_image_refresh = true      => SI
force_image_refresh = null      => NO
force_image_refresh = false     => NO

var.force_image_refresh ? "SI" : "NO"