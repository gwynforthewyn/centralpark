resource "aws_security_group" "allow_ssh_access" {
  vpc_id = aws_vpc.jenkins_vpc.id
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["67.176.80.56/32"]
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
    cidr_blocks = ["67.176.80.56/32"]
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

resource "aws_instance" "jenkins" {

  ami = "ami-0c54097900b6afcbe" #fedora
  
  associate_public_ip_address = true
  key_name = aws_key_pair.access_aws.key_name
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh_access.id, aws_security_group.allow_http_access.id]
  subnet_id = aws_subnet.jenkins_subnet.id

  user_data = <<-EOS
  #!/bin/bash

  dnf -y update
  
  dnf -y install dnf-plugins-core

  dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo

  dnf -y install docker-ce docker-ce-cli

  systemctl enable docker.service
  systemctl enable containerd.service
  systemctl start docker

  usermod -aG docker fedora

  sudo -u fedora bash -c "docker pull jenkins/jenkins:lts"
  EOS



  tags = {
    Name = "jinkies"
  }
}

output "inspect_public_address" {
  value = aws_instance.jenkins.public_ip
}
