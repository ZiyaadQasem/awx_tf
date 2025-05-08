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
      "echo Hello from Terraform on ${self.connection.host} > /tmp/hello-from-tf.txt"
    ]
  }
}
