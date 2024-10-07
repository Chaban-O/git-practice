#Створюємо ALB для розподілу трафіку по інстансам
resource "aws_lb" "application-lb" {
    name            = var.lb_name
    internal        = false
    ip_address_type     = "ipv4"
    load_balancer_type = "application"
    security_groups = var.security_group_ids
    subnets = var.subnet_ids
    tags = {
        Name = var.lb_name
    }
}


#Створюємо таргет груп для маршутизації трафіку
resource "aws_lb_target_group" "target-group" {
    health_check {
        interval            = 10
        path                = "/"
        protocol            = var.target_group_protocol
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
    }
    name          = var.target_group_name
    port          = var.target_group_port
    protocol      = var.target_group_protocol
    target_type   = "instance"
    vpc_id = var.vpc_id
}


#Створємо ліснер для перенаправлення вхідного трафіку з ALB до інстансу
resource "aws_lb_listener" "alb-listener" {
    load_balancer_arn          = aws_lb.application-lb.arn
    port                       = 80
    protocol                   = var.target_group_protocol
    default_action {
        target_group_arn         = aws_lb_target_group.target-group.arn
        type                     = "forward"
    }
}


#Привязуємо таргет групу до аплікатіон лоад беленсера
resource "aws_lb_target_group_attachment" "ec2_attach" {
    count = length(var.instance_ids)
    target_group_arn = aws_lb_target_group.target-group.arn
    target_id        = var.instance_ids[count.index]
}

data "aws_subnet" "example" {
    filter {
        name = "vpc-id"
        values = [var.vpc_id]
    }
}

data "aws_subnet" "example" {
    for_each = toset(data.aws_subnet.example.id)
    id = each.value
}