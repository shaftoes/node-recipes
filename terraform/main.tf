resource "digitalocean_droplet" "matrix-server" {
  image              = ""
  name               = "matrix-server"
  region             = "${var.region}"
  size               = "1gb"
  ipv6               = true
  private_networking = true
  tags               = ["matrix-server"]

  connection {
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "matrix-bootstrap.sh"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/matrix-bootstrap.sh",
      "/tmp/matrix-bootstrap.sh ${var.host} ${var.link_preview}",
      "/tmp/",
    ]
  }
}
