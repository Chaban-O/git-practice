# Вказуємо провайдер і регіон AWS
provider "aws" {
  region = "us-east-1"
}

# Додаємо ваш SSH ключ
resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub") # Вкажіть шлях до вашого публічного SSH ключа
}

# Виклик модуля secrets
module "secrets" {
  source = "./modules/secrets"
  secret_name = "my-test-secret-key-v59"
  password_length = 16
  recovery_window_in_days = 7
}

# Виклик модуля Security group
module "aws_security_group" {
  source = "./modules/security-group"
}

# Виклик модуля IAM role
module "iam_role" {
  source = "./modules/iam_role"
  instance_profile_name = "ec2_secret_manager_role"
}

# Виклик EC2 модуля
module "ec2_instance" {
  source = "./modules/ec2-instance"
  ami = data.aws_ami.my_packer_ami.id
  instance_type = "t2.micro"
  instance_name = "MyTerraformInstance"
  ebs_size = 10
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [module.aws_security_group.allow_ssh_http_https]
  instance_profile_name = module.iam_role.instance_profile_name
  secret_id = module.secrets.secret_id
  aws_region = var.aws_region
}

# Виклик модуля Application Load Balancer
module "alb" {
  source = "./modules/alb"
  lb_name           = "test-alb"
  security_group_ids = [module.aws_security_group.allow_ssh_http_https]
  subnet_ids = [
    data.aws_subnet.my-subnet-1.id,
    data.aws_subnet.my-subnet-2.id,
    data.aws_subnet.my-subnet-3.id,
    data.aws_subnet.my-subnet-4.id,
    data.aws_subnet.my-subnet-5.id,
    data.aws_subnet.my-subnet-6.id
  ]
  target_group_name = "test-tg"
  health_check_port = 80
  vpc_id            = data.aws_vpc.default.id
  target_group_protocol = "HTTP"
  autoscaling_group = module.autoscaling.asg_name
  instance_ids = module.ec2_instance.instance_ids
}

#Виклик модуля Autoscaling group
module "autoscaling" {
  source = "./modules/autoscaling"
  ami_id = data.aws_ami.my_packer_ami.id
  aws_lb_target_group_arn = module.alb.target_group_arn
  instance_security_group = module.aws_security_group.allow_ssh_http_https
  ssh_public_key_name = aws_key_pair.deployer.key_name
  instance_type = "t2.micro"
  subnets = [
    data.aws_subnet.my-subnet-1.id,
    data.aws_subnet.my-subnet-2.id,
    data.aws_subnet.my-subnet-3.id,
    data.aws_subnet.my-subnet-4.id,
    data.aws_subnet.my-subnet-5.id,
    data.aws_subnet.my-subnet-6.id
  ]
  desired_capacity = 2
  max_size = 3
  min_size = 1
}

#Виклик RDS модуля
# terraform import module.rds_instance.aws_db_instance.myapp-db arn:aws:rds:us-east-1:699475951891:db:myapp-db
module "rds_instance" {
  source = "./modules/rds-instance"
  allocated_storage = 20
  db_instance_class = "db.t4g.micro"
  engine_type       = "mysql"
  rds_db_name       = "myappdb"
  vpc_security_group_ids = [module.aws_security_group.allow_ssh_http_https]
  cluster_identifier = "database1"
  engine_version = "8.0.35"
}
