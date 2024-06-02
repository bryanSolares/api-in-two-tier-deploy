resource "aws_launch_template" "template_app" {
  name = "api_template"

  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  image_id               = "ami-00beae93a2d981137"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.private_access_instance.id, aws_security_group.private_access_instance.id]
  user_data              = filebase64("${path.module}/userdata/init_app.sh")
  key_name               = aws_key_pair.bastion_key.key_name

}

# Target group
resource "aws_lb_target_group" "api_service" {
  name     = "api-service-tg"
  port     = 3500
  protocol = "HTTP"
  vpc_id   = aws_vpc.default_vpc.id
  health_check {
    path    = "/"
    matcher = 200
  }
}

resource "aws_alb_listener" "alb_listener_api" {
  load_balancer_arn = aws_lb.api_service_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_service.arn
  }
}

# Loadbalancer
resource "aws_lb" "api_service_lb" {
  name               = "api-server-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

# Auto scaling 
resource "aws_autoscaling_group" "api_service" {
  name                      = "API Server AutoScaling"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true

  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  target_group_arns   = [aws_lb_target_group.api_service.arn]

  launch_template {
    id      = aws_launch_template.template_app.id
    version = aws_launch_template.template_app.latest_version
  }

}

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion"
  public_key = file("./key-ssh/bastion.pub")
}


resource "aws_instance" "bastion_host" {
  ami                    = "ami-0d191299f2822b1fa"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.bastion_ssh_access.id]
  key_name               = aws_key_pair.bastion_key.key_name

  tags = {
    Name = "Bastion"
  }

}
