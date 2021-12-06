locals {
  PRIVATE_IPS = concat(aws_spot_instance_request.spot-instance.*.private_ip, aws_instance.od-instance.*.private_ip)
}


resource "null_resource" "app-setup" {
  count        = length(local.PRIVATE_IPS)
  triggers = {
    //private_ip = element(local.PRIVATE_IPS, count.index)
    abc = timestamp()
  }
  provisioner "remote-exec" {
    connection {
      host     = element(local.PRIVATE_IPS, count.index)
      user     = local.ssh_user
      password = local.ssh_pass
    }
    inline = [
      "sudo yum install python3-pip -y",
      "sudo pip3 install pip --upgrade",
      "sudo pip3 install ansible",
      "ansible-pull -U https://github.com/venuk-1502/devops.git ansible/roboshop/roboshop-pull.yml -e COMPONENT=${var.COMPONENT} -e ENV=${var.ENV}"
    ]
  }
}