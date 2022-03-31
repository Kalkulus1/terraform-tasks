# Target Group Creation

resource "aws_lb_target_group" "tg" {
  name        = "TargetGroup"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.flugel_vpc.id

  #   health_check {
  #     enabled = true
  #     path = "/"
  #     port = "80"
  #     protocol = "HTTP"
  #     healthy_threshold = 3
  #     unhealthy_threshold = 2
  #     interval = 90
  #     timeout = 20
  #     matcher = "200"
  #   }

  tags = var.tags
}

# Target Group Attachment with Instance
resource "aws_alb_target_group_attachment" "tgattachment" {
  count            = length(aws_instance.flugel_task2_ec2_instance.*.id)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(aws_instance.flugel_task2_ec2_instance.*.id, count.index)
}

# Application Load balancer
resource "aws_lb" "load_balancer" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_web.id]
  subnets            = aws_subnet.public_subnet.*.id

  tags = var.tags
}

# Listner
resource "aws_lb_listener" "app_listiner" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Listener Rule
resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.app_listiner.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn

  }

  condition {
    path_pattern {
      values = ["/var/www/html/index.html"]
    }
  }
}
