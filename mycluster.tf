provider "aws" {
    region = "${var.region}"
}

module "consul-certificates" {
    source = "./terraform/vault-pki"
    temp_file = "./consul_tmp.json"
    certificate = "${var.consul_certificate}"
    private_key = "${var.consul_key}"
    issuer_certificate = "${var.root_certificate}"
    common_name = "${var.common_name}"
    ip_sans = "${var.ip_sans}"
    alt_names = "${var.alt_names}"
    vault_token = "${var.vault_token}"
    vault_addr = "${var.vault_addr}"
}

module "vault-certificates" {
    source = "./terraform/vault-pki"
    temp_file = "./vault_tmp.json"
    certificate = "${var.vault_certificate}"
    private_key = "${var.vault_key}"
    issuer_certificate = "${var.vault_root_certificate}"
    common_name = "${var.common_name}"
    ip_sans = "${var.ip_sans}"
    alt_names = "${var.alt_names}"
    vault_token = "${var.vault_token}"
    vault_addr = "${var.vault_addr}"
}

module "website-certificates" {
    source = "./terraform/vault-pki"
    temp_file = "./website_tmp.json"
    certificate = "./ssl/www.crt"
    private_key = "./ssl/www.key"
    issuer_certificate = "./ssl/www.root.crt"
    common_name = "www.immutability.io"
    ip_sans = "${var.ip_sans}"
    alt_names = "localhost"
    vault_token = "${var.vault_token}"
    vault_addr = "${var.vault_addr}"
}

module "login-certificates" {
    source = "./terraform/vault-pki"
    temp_file = "./website_tmp.json"
    certificate = "./ssl/login.crt"
    private_key = "./ssl/login.key"
    issuer_certificate = "./ssl/login.root.crt"
    common_name = "login.immutability.io"
    ip_sans = "${var.ip_sans}"
    alt_names = "localhost"
    vault_token = "${var.vault_token}"
    vault_addr = "${var.vault_addr}"
}

module "service-certificates" {
    source = "./terraform/vault-pki"
    temp_file = "./service_tmp.json"
    certificate = "./ssl/service.crt"
    private_key = "./ssl/service.key"
    issuer_certificate = "./ssl/service.root.crt"
    common_name = "prototype.service.consul"
    ip_sans = "${var.ip_sans}"
    alt_names = "localhost,*.immutability.io"
    vault_token = "${var.vault_token}"
    vault_addr = "${var.vault_addr}"
}

module "fabio-certificates" {
    source = "./terraform/vault-pki"
    temp_file = "./service_tmp.json"
    certificate = "./ssl/fabio.crt"
    private_key = "./ssl/fabio.key"
    issuer_certificate = "./ssl/fabio.root.crt"
    common_name = "fabio.immutability.io"
    ip_sans = "${var.ip_sans}"
    alt_names = "localhost,*.immutability.io,*.service.consul"
    vault_token = "${var.vault_token}"
    vault_addr = "${var.vault_addr}"
}

module "bastion" {
    source = "./terraform/bastion"
    ami = "${var.ami}"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tagName = "${var.unique_prefix}-bastion"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
}

module "consul-cluster" {
    source = "./terraform/consul-cluster"
    ami = "${var.ami}"
    servers = "${var.servers}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    bastion_public_ip = "${module.bastion.public_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tagName = "${var.unique_prefix}-consul"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${module.consul-certificates.certificate}"
    consul_key = "${module.consul-certificates.private_key}"
    root_certificate = "${module.consul-certificates.issuer_certificate}"
    password_file = "${var.password_file}"
}

module "consul-service" {
    source = "./terraform/consul-service"
    instance_type = "t2.nano"
    consul_cluster_ips = "${module.consul-cluster.private_server_ips}"
    ami = "${var.ami}"
    service_count = "${var.service_count}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    bastion_public_ip = "${module.bastion.public_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tagName = "${var.unique_prefix}-service"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${module.consul-certificates.certificate}"
    consul_key = "${module.consul-certificates.private_key}"
    service_certificate = "${module.service-certificates.certificate}"
    service_key = "${module.service-certificates.private_key}"
    service_root_certificate = "${module.service-certificates.issuer_certificate}"
    root_certificate = "${module.consul-certificates.issuer_certificate}"
}

module "vault-service" {
    source = "./terraform/vault-service"
    instance_type = "t2.nano"
    consul_cluster_ips = "${module.consul-cluster.private_server_ips}"
    ami = "${var.ami}"
    service_count = "2"
    domain_name="${var.domain_name}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    keybase_keys  = "${var.keybase_keys}"
    key_threshold = "${var.key_threshold}"
    bastion_public_ip = "${module.bastion.public_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tagName = "${var.unique_prefix}-vault"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${module.consul-certificates.certificate}"
    consul_key = "${module.consul-certificates.private_key}"
    vault_certificate = "${module.vault-certificates.certificate}"
    vault_key = "${module.vault-certificates.private_key}"
    root_certificate = "${module.consul-certificates.issuer_certificate}"
}

module "website" {
    source = "./terraform/website"
    nginx_config = "./config/website.nginx.conf"
    consul_cluster_ips = "${module.consul-cluster.private_server_ips}"
    ami = "${var.ami}"
    service_count = "${var.service_count}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    bastion_public_ip = "${module.bastion.public_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tagName = "${var.unique_prefix}-website"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${module.consul-certificates.certificate}"
    consul_key = "${module.consul-certificates.private_key}"
    website_root_certificate = "${module.website-certificates.issuer_certificate}"
    website_certificate = "${module.website-certificates.certificate}"
    website_key = "${module.website-certificates.private_key}"
    root_certificate = "${module.consul-certificates.issuer_certificate}"
    password_file = "${var.password_file}"
}

module "login" {
    source = "./terraform/website"
    nginx_config = "./config/login.nginx.conf"
    consul_cluster_ips = "${module.consul-cluster.private_server_ips}"
    ami = "${var.ami}"
    service_count = "${var.service_count}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    bastion_public_ip = "${module.bastion.public_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tagName = "${var.unique_prefix}-login"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${module.consul-certificates.certificate}"
    consul_key = "${module.consul-certificates.private_key}"
    website_root_certificate = "${module.login-certificates.issuer_certificate}"
    website_certificate = "${module.login-certificates.certificate}"
    website_key = "${module.login-certificates.private_key}"
    root_certificate = "${module.consul-certificates.issuer_certificate}"
    password_file = "${var.password_file}"
}


module "fabio" {
    source = "./terraform/fabio"
    consul_cluster_ips = "${module.consul-cluster.private_server_ips}"
    ami = "${var.ami}"
    service_count = "2"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    bastion_public_ip = "${module.bastion.public_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tagName = "${var.unique_prefix}-fabio"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${module.consul-certificates.certificate}"
    consul_key = "${module.consul-certificates.private_key}"
    root_certificate = "${module.consul-certificates.issuer_certificate}"
    fabio_certificate = "${module.fabio-certificates.certificate}"
    fabio_key = "${module.fabio-certificates.private_key}"
    fabio_root_certificate = "${module.fabio-certificates.issuer_certificate}"
    password_file = "${var.password_file}"
}


resource "aws_iam_server_certificate" "consul_certificate" {
    name_prefix      = "consul"
    certificate_body = "${module.consul-certificates.certificate_body}"
    private_key      = "${module.consul-certificates.private_key_body}"

    lifecycle {
        create_before_destroy = true
    }
}

module "consul-ui-load-balancer" {
    vpc_id = "${var.vpc_id}"
    subnet_ids = "${var.subnet_id}"
    source = "./terraform/load-balancer"
    tagName = "${var.unique_prefix}-consul-ui"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    ssl_certificate_id = "${aws_iam_server_certificate.consul_certificate.arn}"
    instance_ids = ["${module.consul-cluster.instance_ids}"]
}

resource "aws_route53_record" "consul" {
   zone_id = "${var.aws_route53_zone_id}"
   name = "consul.${var.domain_name}"
   type = "CNAME"
   ttl = "10"
   records = ["${module.consul-ui-load-balancer.dns_name}"]
}

data "terraform_remote_state" "consul" {
    backend = "s3"
    config {
        bucket = "${var.s3_tfstate_bucket}"
        key = "consul-terraform/terraform.tfstate"
        region = "${var.region}"
        encrypt = "true"
    }
}

resource "aws_route53_record" "website" {
    zone_id = "${var.aws_route53_zone_id}"
    name = "www.immutability.io"
    type = "A"
    ttl = "10"
    records = ["${module.website.public_server_ips}"]
}

resource "aws_route53_record" "login" {
    zone_id = "${var.aws_route53_zone_id}"
    name = "login.immutability.io"
    type = "A"
    ttl = "10"
    records = ["${module.login.public_server_ips}"]
}


resource "aws_route53_record" "fabio_a" {
    zone_id = "${var.aws_route53_zone_id}"
    name = "fabio.${var.domain_name}"
    type = "A"
    ttl = "10"
    weighted_routing_policy {
      weight = 50
    }
    set_identifier = "fabio_a"
    records = ["${element(module.fabio.public_server_ips, 0)}"]
}

resource "aws_route53_record" "fabio_b" {
    zone_id = "${var.aws_route53_zone_id}"
    name = "fabio.${var.domain_name}"
    type = "A"
    ttl = "10"
    weighted_routing_policy {
      weight = 50
    }
    set_identifier = "fabio_b"
    records = ["${element(module.fabio.public_server_ips, 1)}"]
}
