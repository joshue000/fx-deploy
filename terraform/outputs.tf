output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i banco-deploy-.pem ubuntu@${aws_instance.app.public_ip}"
}

output "frontend_url" {
  description = "Angular frontend"
  value       = "http://${aws_instance.app.public_ip}:4200"
}

output "api_url" {
  description = "REST API"
  value       = "http://${aws_instance.app.public_ip}:3000"
}

output "swagger_url" {
  description = "Swagger UI (interactive API docs)"
  value       = "http://${aws_instance.app.public_ip}:3000/api/v1/docs"
}

output "metrics_url" {
  description = "Prometheus metrics endpoint"
  value       = "http://${aws_instance.app.public_ip}:3000/metrics"
}

output "prometheus_url" {
  description = "Prometheus"
  value       = "http://${aws_instance.app.public_ip}:9090"
}

output "grafana_url" {
  description = "Grafana dashboards"
  value       = "http://${aws_instance.app.public_ip}:3100"
}
