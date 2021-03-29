resource "aws_vpc" "jenkins_vpc" {
  cidr_block = "192.168.8.0/22"
}