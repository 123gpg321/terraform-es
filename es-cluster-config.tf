#Authenticate to AWS provider

provider "aws" {
    access_key = "AKIAJ46----------"
    secret_key = "BaFWAjBpb8+J61AO---------------------------"
    region = "us-east-1"
}

#Create 3 EC2 Instances for ElasticSearch cluster nodes

resource "aws_instance" "es-node-1" {
    ami = "ami-0d4cfd66"
    key_name = "id_rsa"
    security_groups = ["georgi-es-group"]
    instance_type = "t2.micro"
    tags {
        Owner = "Georgi"
	Environment = "Production"
    }
}

resource "aws_instance" "es-node-2" {
    ami = "ami-0d4cfd66"
    key_name = "id_rsa"
    security_groups = ["georgi-es-group"]
    instance_type = "t2.micro"
    tags {
        Owner = "Georgi"
	Environment = "Production"
    }
}

resource "aws_instance" "es-node-3" {
    ami = "ami-0d4cfd66"
    key_name = "id_rsa"
    security_groups = ["georgi-es-group"]
    instance_type = "t2.micro"
    tags {
        Owner = "Georgi"
	Environment = "Production"
    }
}

# Create new load balancer for EC2 ElasticSearch Cluster

resource "aws_elb" "elasticsearch-loadbalancer" {
  name = "lb-es"
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1d"
  ]

  listener {
    instance_port = 8000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8000/isALive.json"
    interval = 30
  }

  instances = [
    "${aws_instance.es-node-1.id}",
    "${aws_instance.es-node-2.id}",
    "${aws_instance.es-node-3.id}"
  ]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
}
