#Створюємо ALB для розподілу трафіку по інстансам
resource "aws_lb" "application-lb" {
    name               = var.lb_name
    internal           = false
    ip_address_type    = "ipv4"
    load_balancer_type = "application"
    security_groups    = var.security_group_ids
    subnets            = var.subnet_ids
    tags = {
        Name = var.lb_name
    }
    #Це означає, що ресурс (наприклад, балансувальник навантаження, RDS інстанс чи будь-який інший ресурс, який підтримує цю опцію)
    #можна буде видалити без будь-яких додаткових запитів на підтвердження
    enable_deletion_protection = false
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
    name        = var.target_group_name
    port        = var.health_check_port
    protocol    = var.target_group_protocol
    target_type = "instance"
    vpc_id      = var.vpc_id
}

# Підключення Target Group до AutoScaling Group
resource "aws_autoscaling_attachment" "asg_attachment" {
    autoscaling_group_name = var.autoscaling_group
    lb_target_group_arn    = aws_lb_target_group.target-group.arn
}
