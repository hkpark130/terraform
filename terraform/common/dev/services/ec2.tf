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

  # 호스트/컨테이너에서 실제 listening 중인 포트만 명시.
  # docker ps + ss -tlnp 로 검증됨 (2026-05-01 기준).
  # GitHub Actions runner SSH 동적 추가/삭제는 AWS API 직접 호출이라
  # terraform 이 모르고 지나감 → ignore_changes 불필요.

  ingress {
    description      = "HTTP (edge-proxy nginx)"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS (edge-proxy nginx)"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "SSH (admin IPs)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "27.142.99.202/32",
      "119.201.72.35/32",
      "221.110.31.103/32",
      "221.149.51.217/32",
    ]
  }

  ingress {
    description      = "chatbot-api / chat-service (FastAPI)"
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "backend-spring-app"
    from_port        = 8100
    to_port          = 8100
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Laravel/Apache (house price prediction)"
    from_port        = 8200
    to_port          = 8200
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "go-jwt-web (Apache)"
    from_port        = 8300
    to_port          = 8300
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Laravel internal nginx (home IP + self-SG)"
    from_port   = 8201
    to_port     = 8201
    protocol    = "tcp"
    cidr_blocks = ["27.143.63.88/32"]
    self        = true
  }

  ingress {
    description = "MySQL (home IP + self-SG)"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["27.143.63.88/32"]
    self        = true
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
