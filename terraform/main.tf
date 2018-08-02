resource "digitalocean_droplet" "matrix-server" {
  image              = "debian-8-x64"
  name               = "matrix-server"
  region             = "${var.region}"
  size               = "1gb"
  ipv6               = true
  private_networking = true

  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  connection {
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "matrix-bootstrap.sh"
    destination = "/tmp/matrix-bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/matrix-bootstrap.sh",
      "/tmp/matrix-bootstrap.sh ${var.host} ${var.link_preview}",
    ]
  }
}
