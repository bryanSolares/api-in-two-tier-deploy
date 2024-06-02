output "vpc_id" {
  value = aws_vpc.default_vpc.id
}

output "public_subnet_id_1" {
  value = aws_subnet.public_subnet_1.id
}

output "public_subnet_id_2" {
  value = aws_subnet.public_subnet_2.id
}

output "private_subnet_id_1" {
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet_id_2" {
  value = aws_subnet.private_subnet_2.id
}

output "alb_dns" {
  value = "http://${aws_lb.api_service_lb.dns_name}"
}

output "bastion_public_ip" {
  value = aws_instance.bastion_host.public_ip
}
