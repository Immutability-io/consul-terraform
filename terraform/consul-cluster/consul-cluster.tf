provider "aws" {
    region = "${var.region}"
}

module "consul" {
    source = "github.com/Immutability-io/consul-terraform//terraform/consul-node"
    ami = "${var.ami}"
    private_key = "${var.private_key}"
    key_name = "${var.key_name}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    ingress_22 = "${var.ingress_22}"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
}

data "template_file" "template-consul-config" {
    template = "${file(var.consul_template)}"
    vars {
        retry_join = "${join("\",\"", module.consul.private_server_ips)}"
        datacenter = "${var.datacenter}"
        gossip_encryption_key = "${var.gossip_encryption_key}"
    }
}

resource "null_resource" "consul_cluster" {
    count = "${var.servers}"
    connection {
        host = "${element(module.consul.public_server_ips, count.index)}"
        user = "ubuntu"
        private_key = "${var.private_key}"
    }

    provisioner "file" {
        content = "${data.template_file.template-consul-config.rendered}"
        destination = "/tmp/consul.json"
    }

    provisioner "file" {
        source = "${var.root_certificate}"
        destination = "/tmp/root.crt"
    }

    provisioner "file" {
        source = "${var.consul_certificate}"
        destination = "/tmp/consul.crt"
    }

    provisioner "file" {
        source = "${var.consul_key}"
        destination = "/tmp/consul.key"
    }

    provisioner "file" {
        source = "${var.password_file}"
        destination = "/tmp/.htpasswd"
    }

    provisioner "remote-exec" {
        scripts = [
            "./scripts/setup_nginx_auth.sh",
            "./scripts/setup_certs.sh",
            "./scripts/consul_service.sh",
            "./scripts/reload_nginx.sh"
        ]
    }
}