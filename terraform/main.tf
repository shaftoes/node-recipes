data "template_file" "matrix_nginx" {
  template = "${file("templates/matrix-nginx.conf")}"

  vars {
    matrix_domain = "${var.matrix_subdomain}.${var.server_name}"
  }
}

data "template_file" "homeserver" {
  template = "${file("templates/homeserver.yaml")}"

  vars {
    server_name = "${var.server_name}"
  }
}

resource "digitalocean_droplet" "matrix-server" {
  image              = "debian-9-x64"
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
    source      = "bootstrap"
    destination = "/tmp"
  }

  provisioner "file" {
    content     = "${data.template_file.matrix_nginx.rendered}"
    destination = "/tmp/bootstrap/matrix_nginx.conf"
  }

  provisioner "file" {
    content     = "${data.template_file.homeserver.rendered}"
    destination = "/tmp/bootstrap/homeserver.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap/*",
      "/tmp/bootstrap/bootstrap.sh",
      "/tmp/bootstrap/postgres-bootstrap.sh",
      "/tmp/bootstrap/matrix-bootstrap.sh ${var.server_name}",
    ]
  }
}

resource "digitalocean_record" "matrix-server-a-record" {
  domain = "${var.server_name}"
  type   = "A"
  name   = "matrix"
  value  = "${digitalocean_droplet.matrix-server.ipv4_address}"
  ttl    = "60"
}

resource "digitalocean_record" "matrix-srv-record" {
  type     = "SRV"
  name     = "_matrix._tcp"
  port     = "8448"
  priority = "100"
  weight   = "500"
  ttl      = "60"
  domain   = "${var.server_name}"
  value =   "matrix"
}

# configuring letsencrypt + nginx must be done after the DNS record has bee added
resource "null_resource" "matrix-server-a-record" {
  
  depends_on = ["digitalocean_record.matrix-server-a-record"]
  
  connection {
    host             = "${digitalocean_droplet.matrix-server.ipv4_address}"
    user             = "root"
    type             = "ssh"
    private_key      = "${file(var.pvt_key)}"
    timeout          = "2m"
  }
  provisioner "remote-exec" {
    inline           = [
      "/tmp/bootstrap/matrix-nginx-bootstrap.sh ${var.matrix_subdomain}.${var.server_name} ${var.nginx_email}",
    ]
  }
}

