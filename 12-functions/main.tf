variable "env" {
  default = "dev"
}

locals {
  upper_env   = upper(var.env)
  tag_keys    = ["team", "owner"]
  tag_values  = ["devops", "pavan"]
  merged_tags = zipmap(local.tag_keys, local.tag_values)
}

output "upper_env" {
  value = local.upper_env
}

output "merged_tags" {
  value = local.merged_tags
}

locals {
  file_content = file("./welcome.tpl")
}

output "readme" {
  value = local.file_content
}

locals {
  rendered = templatefile("./welcome.tpl", {
    name    = "Pavan"
    project = "Terraform Bootcamp"
  })
}

output "greeting" {
  value = local.rendered
}

output "subnet" {
  value = cidrsubnet("10.0.0.0/16", 4, 2)
}

variable "is_production" {
  default = false
}

output "instance_type" {
  value = var.is_production ? "Standard_F4" : "Standard_B2"
}
