resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo Hello from Terraform > hello.txt"
  }
  provisioner "local-exec" {
    when    = "destroy"
    command = "echo Destroying the resource!"
  }
}
