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

resource "local_file" "letsencrypt-clusterissuer" {
  content  = <<EOT
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    email: ${var.email}
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt
    solvers:
    - http01:
        ingress:
          class: public
EOT
  filename = "${path.module}/../../manifests/letsencrypt-clusterissuer.yaml"
}
