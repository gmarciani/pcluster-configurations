resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "public_az1" {
  availability_zone = "${var.region}a"
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    self			 = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}