variable "remote_ips" {
  type = list(string)
}

variable "ssh_user" {
  type = string
}

variable "ssh_private_key" {
  type = string
}

resource "null_resource" "remote_exec" {
  count = length(var.remote_ips)

  connection {
    type        = "ssh"
    host        = var.remote_ips[count.index]
    user        = var.ssh_user
    private_key = replace(var.ssh_private_key, "\\n", "\n")
  }

  provisioner "remote-exec" {
    inline = [
    <<-EOF
      echo Hello from Terraform on ${var.remote_ips[count.index]} > /tmp/hello-from-terraform2.txt
      mkdir -p /tmp/tf
      touch /tmp/tf/init.log
      echo Initialized on $(date) >> /tmp/tf/init.log
    EOF
  ]
  }
}
