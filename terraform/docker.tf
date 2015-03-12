
resource "aws_security_group" "docker-initiation-sg" {
    name = "docker-initiation-sg"
    description = "Allow all inbound traffic"

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "trainer" {
    key_name = "docker-initiation"
    ami = "ami-f0b11187"
    instance_type = "c3.large"
    tags {
        Name = "docker-initiation trainer"
        Group = "docker-initiation"
    }
    subnet_id = "${aws_subnet.docker-initiation-net.id}"
}

resource "aws_instance" "docker" {
    count = "${var.instance_count}"
    key_name = "docker-initiation"
    ami = "ami-f0b11187"
    instance_type = "t2.small"
    tags {
        Name = "docker-initiation#${count.index}"
        Group = "docker-initiation"
    }
    subnet_id = "${aws_subnet.docker-initiation-net.id}"
}

resource "aws_subnet" "docker-initiation-net" {
  vpc_id = "vpc-6648a303"
  cidr_block = "172.30.9.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1b"
  tags {
          Name = "docker-initiation subnet"
          Group = "docker-initiation"
      }
}

#resource "aws_route53_record" "docker-record" {
#    name = "${concat("docker-",lookup(var.groups,count.index), ".aws.xebiatechevent.info")}"
#    count = "${var.instance_count}"
#    zone_id = "Z28O5PDK1WPCSR"
#    type = "A"
#    records = ["${element(aws_instance.docker.*.public_ip, count.index)}"]
#    ttl = "1"
#}
