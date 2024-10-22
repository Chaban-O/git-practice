resource "aws_launch_template" "app_template" {
  name_prefix   = "my-app-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name = var.ssh_public_key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.instance_security_group]
  }

  # Означає, що при внесенні змін до ресурсу, новий ресурс буде створений перед тим, як старий буде видалений
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnets
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  target_group_arns   = [var.aws_lb_target_group_arn]
  termination_policies = ["OldestInstance"]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "my-app-instance"
  }
}

# Конфігурація керування планового масштабування
resource "aws_autoscaling_schedule" "scale-up" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  scheduled_action_name  = "scale-up-time"
  time_zone = "Europe/Kyiv"
  recurrence = "25 23 * * *"
  min_size = 1
  desired_capacity = 3
  max_size = 4
}

resource "aws_autoscaling_schedule" "scale-down" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  scheduled_action_name  = "scale-down-time"
  time_zone = "Europe/Kyiv"
  recurrence = "35 23 * * *"
  min_size = 1
  desired_capacity = 2
  max_size = 3
}

# * * * * *
# | | | | |
# | | | | +----- День тижня (0 - 7) (неділя - 0 або 7)
# | | | +------- Місяць (1 - 12)
# | | +--------- День місяця (1 - 31)
# | +----------- Година (0 - 23)
# +------------- Хвилина (0 - 59)