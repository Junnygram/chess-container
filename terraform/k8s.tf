resource "kubernetes_deployment" "name" {
  metadata {
    name = "chess-app"
    labels = {
      "type" = "backend"
      "app"  = "nodeapp"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "type" = "backend"
        "app"  = "nodeapp"
      }
    }

    template {
      metadata {
        name = "chesspod"
        labels = {
          "type" = "backend"
          "app"  = "nodeapp"

        }
      }

      spec {
        container {
          name  = "chess-container"
          image = var.container_image

          port {
            container_port = 80
          }
        }
      }
    }
  }
}
resource "google_compute_address" "default" {
  name= "ipservice"
  region = var.region
}
resource "kubernetes_service" "appservice" {
    metadata {
      name = "react-app-load-balancer-service"
    }
    spec {
      type = "loadbalancer"
      load_balancer_ip = google_compute_address.default.address
      port {
        port = 80
        target_port = 80
      }
      selector = {
        "type" = "backend"
        "app"  = "chess"
      }
    }
  
}