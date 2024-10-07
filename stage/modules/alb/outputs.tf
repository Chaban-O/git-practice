output "elb-dns-name" {
  description = "DNS-ім'я Application Load Balancer (ALB), яке використовується для доступу до ALB через інтернет"
  value = aws_lb.application-lb.dns_name
}

output "lb_arn" {
    description = "ARN (Amazon Resource Name) Application Load Balancer, який унікально ідентифікує ALB у AWS"
    value = aws_lb.application-lb.arn
}

output "target_group_arn" {
    description = "ARN цільової групи, до якої прив'язуються EC2 інстанси для маршрутизації трафіку через ALB"
    value = aws_lb_target_group.target-group.arn
}

output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.example : s.cidr_block]
}