##############################
# ec2
##############################
resource "aws_instance" "this" {
  security_groups             = [aws_security_group.this.name]
  subnet_id                   = aws_subnet.this.id
  vpc_security_group_ids      = [aws_security_group.this.id]
  ami                         = "ami-006e2f9fa7597680a"
  instance_type               = "t2.micro"
  iam_instance_profile        = "Instance-Profile"
  user_data_replace_on_change = false

  tags = {
    Name = "개인 포폴"
    name = "ec2-server-hkpark"
  }
}

resource "aws_subnet" "this" {
  cidr_block              = "172.31.32.0/20"
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
}

resource "aws_vpc" "this" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_security_group" "this" {
  name        = "launch-wizard-1"
  vpc_id      = aws_vpc.this.id
  description = "launch-wizard-1 created 2021-03-05T00:08:18.373+09:00"

  lifecycle {
    ignore_changes = [
      ingress,
    ]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  tags = {
    Name = "개인포폴 그룹"
  }
}
