output "direccion_ip" {
    value = docker_container.mi_contenedor.ip_address
}

output "redes" {
    value = docker_container.mi_contenedor.network_data
}

output "red" {
    value = docker_container.mi_contenedor.network_data[0]
}

output "ip_desde_red" {
    value = docker_container.mi_contenedor.network_data[0].ip_address
}

output "ips_desde_redes" {
    value = docker_container.mi_contenedor.*.ip_address
}

