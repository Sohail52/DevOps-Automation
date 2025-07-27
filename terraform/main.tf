provider "aws" {
  region = "us-east-1"
}

variable "key_name" {
  description = "Name of the AWS key pair"
  default     = "my-devops-key"
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-security-group"
  description = "Allow inbound traffic for Flask, Prometheus, and Grafana"

  ingress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOps Security Group"
  }
}

resource "aws_instance" "devops_server" {
  ami             = "ami-0c02fb55956c7d316"
  instance_type   = "t2.micro"
  key_name        = var.key_name
  security_groups = [aws_security_group.devops_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y python3 python3-pip git docker
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user
  EOF

  tags = {
    Name = "DevOps Server"
  }
}

output "instance_ip" {
  value = aws_instance.devops_server.public_ip
}
