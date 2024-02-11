resource "local_file" "nginx-ingress" {
  content  = <<EOT
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  creationTimestamp: null
  name: nginx
spec:
  rules:
  - host: nginx.${aws_eip.microk8s-eip.public_ip}.sslip.io
    http:
      paths:
      - backend:
          service:
            name: nginx
            port:
              number: 80
        path: /
        pathType: Prefix
status:
  loadBalancer: {}
EOT
  filename = "${path.module}/../../manifests/nginx-ingress.yaml"
}
