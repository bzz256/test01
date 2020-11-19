terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    docker = {
      source = "terraform-providers/docker"
    }
  }
}

provider "kubernetes" {}

resource "docker_image" "k8s-image" {
  name = "k8s:latest"
}

resource "kubernetes_deployment" "demoApp" {
  metadata {
    name = "demo-app"
    labels = {
      App = "k8s"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "k8s"
      }
    }
    template {
      metadata {
        name = "demo-app"
        labels = {
          App = "k8s"
        }
      }
      spec {
        container {
          image = "localhost:5000/k8s"
          name = "demo-app"

          port {
            container_port = 8080
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}