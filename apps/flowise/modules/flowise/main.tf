
// this expects that you have the ebs-csi installed
resource "kubernetes_storage_class" "ebs_gp3" {
  metadata {
    name = "flowise-sc"
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Retain"
  parameters = {
    type = "gp3"
  }
}

resource "kubernetes_namespace" "flowise" { // we could get helm to create this
  metadata {
    name = "flowise"
  }
}

resource "kubernetes_persistent_volume_claim" "ebs_gp3" {
  metadata {
    name      = "flowise-pvc"
    namespace = kubernetes_namespace.flowise.metadata[0].name
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class.ebs_gp3.metadata[0].name
    resources {
      requests = {
        storage = "20Gi"
      }
    }
  }
}

resource "helm_release" "flowise" {
  name = "k8s-flowise"

  namespace  = kubernetes_namespace.flowise.metadata[0].name
  repository = "https://cowboysysop.github.io/charts/"
  chart      = "flowise"

  wait_for_jobs = true

  set {
	name = "persistence.existingClaim"
	value = kubernetes_persistant_volume_claim.ebs_gp3
  }
}
