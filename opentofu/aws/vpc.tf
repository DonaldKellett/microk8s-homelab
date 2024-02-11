resource "aws_vpc" "microk8s-vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "microk8s-subnet" {
  vpc_id     = aws_vpc.microk8s-vpc.id
  cidr_block = var.subnet_cidr
}

resource "aws_internet_gateway" "microk8s-igw" {
  vpc_id = aws_vpc.microk8s-vpc.id
}

resource "aws_route_table" "microk8s-rtb" {
  vpc_id = aws_vpc.microk8s-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.microk8s-igw.id
  }
}

resource "aws_route_table_association" "microk8s-rtb-association" {
  subnet_id      = aws_subnet.microk8s-subnet.id
  route_table_id = aws_route_table.microk8s-rtb.id
}

resource "aws_security_group" "microk8s-sg" {
  name        = "microk8s-sg"
  description = "MicroK8s security group"
  vpc_id      = aws_vpc.microk8s-vpc.id
}

resource "aws_security_group_rule" "microk8s-sg-ingress-0" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.microk8s-sg.id
}

resource "aws_security_group_rule" "microk8s-sg-ingress-1" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.microk8s-sg.id
}

resource "aws_security_group_rule" "microk8s-sg-ingress-2" {
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.microk8s-sg.id
}

resource "aws_security_group_rule" "microk8s-sg-egress-0" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.microk8s-sg.id
}
