output "direccion_ip" {
    value = docker_container.mi_contenedor.ip_address
}

output "id" {
    value = docker_container.mi_contenedor.id
}
