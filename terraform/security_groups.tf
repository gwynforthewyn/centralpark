resource "aws_security_group" "allow_ssh_access" {
  vpc_id = aws_vpc.jenkins_vpc.id
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.allowed_ingress
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_access"
  }
}

resource "aws_security_group" "allow_http_access" {
  vpc_id = aws_vpc.jenkins_vpc.id
  
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = var.allowed_ingress
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_access"
  }
}