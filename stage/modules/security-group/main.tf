# Створюємо Security Group з необхідними правилами
resource "aws_security_group" "allow_ssh_http_https" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH, HTTP, and HTTPS traffic"

  # Динамічно створюємо ingress правила для SSH, HTTP та HTTPS
  dynamic "ingress" {
    for_each = local.allowed_ports
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      protocol = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  }