output "instances" {
  value = aws_instance.Instance[*].id #splat expressions
}