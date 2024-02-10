output "microk8s-reverse-tunnel-proxy-public-ip" {
  value = aws_eip.microk8s-eip.public_ip
}
