provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

provider "helm" {
  kubernetes {
    config_path            = "~/.kube/config"
    config_context_cluster = "minikube"
  }
}

resource "kubernetes_namespace" "my-namespace" {
  metadata {
    name = "my-k8s-namespace"
  }
}

resource "helm_release" "my-helm" {
  name      = "mychart"
  chart     = "./mychart"
  namespace = kubernetes_namespace.my-namespace.id
  atomic    = true
}
