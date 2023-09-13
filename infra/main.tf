
resource "time_static" "now" {}

locals {

  // build some tags for all things
  tags = merge(
    { # excludes kube-specific tags
      "stack"  = var.name
      "expire" = timeadd(time_static.now.rfc3339, var.expire_duration)
    },
    var.extra_tags
  )

}
