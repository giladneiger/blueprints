helm "vault" {
  cluster = "k8s_cluster.${var.vault_k8s_cluster}"
  repository = "https://helm.releases.hashicorp.com"
  chart = "vault"
  version = "0.19.0"
  
  values = "./helm/vault-values.yaml"

  health_check {
    timeout = "120s"
    pods = ["app.kubernetes.io/name=vault"]
  }
}

ingress "vault" {
  source {
    driver = "local"
    
    config {
      port = var.vault_api_port
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.${var.vault_k8s_cluster}"
      address = "vault-ui.default.svc"
      port = var.vault_api_port
    }
  }
}
