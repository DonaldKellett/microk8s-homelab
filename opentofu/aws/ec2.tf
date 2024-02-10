resource "aws_key_pair" "microk8s-node-ssh-pubkey" {
  key_name   = "microk8s-node-ssh-pubkey"
  public_key = file(pathexpand(var.ssh_pubkey_path))
}

resource "aws_eip" "microk8s-eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.microk8s-igw]
}

resource "aws_instance" "microk8s-reverse-tunnel-proxy" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.microk8s-node-ssh-pubkey.key_name
  subnet_id       = aws_subnet.microk8s-subnet.id
  security_groups = [aws_security_group.microk8s-sg.id]

  tags = {
    Name = "microk8s-reverse-tunnel-proxy"
  }
}

resource "aws_eip_association" "microk8s-eip-assoc" {
  instance_id   = aws_instance.microk8s-reverse-tunnel-proxy.id
  allocation_id = aws_eip.microk8s-eip.id
}
