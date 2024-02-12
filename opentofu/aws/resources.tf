resource "local_file" "nginx-ingress" {
  content  = <<EOT
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  creationTimestamp: null
  name: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
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
  tls:
  - hosts:
    - nginx.${aws_eip.microk8s-eip.public_ip}.sslip.io
    secretName: nginx-cert
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
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt
    solvers:
    - http01:
        ingress:
          class: public
EOT
  filename = "${path.module}/../../manifests/letsencrypt-clusterissuer.yaml"
}
