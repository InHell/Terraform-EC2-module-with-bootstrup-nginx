#### main body ####

# Assign ssh key
resource "aws_key_pair" "my_key_pair" {
  key_name   = "ec2"
  public_key = file("${abspath(path.cwd)}/modules/ec2_standalone/ec2.pub")
}

# EC instance creation with bootstrup scripts
resource "aws_instance" "my_EC2" {
  ami           = var.ami_id
  instance_type = var.instance_types
  key_name      = aws_key_pair.my_key_pair.key_name

  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true



# copy folder with APP install files and some needed files to remote EC2 instance via ssh at pipeline build
  provisioner "file" {
    source      = "./modules/ec2_standalone/app-folder"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      #your ssh key must be in main body . you can make it more secure if use some secret's
      private_key = file("./modules/ec2_standalone/ec2")
      host        = self.public_ip
    }
  }
  # there we prepare remote system for run ours bash script located in app-folder above that's we copy on remote EC2
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ubuntu/app-folder/bootstrup.sh",
      "/home/ubuntu/app-folder/bootstrup.sh",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./modules/ec2_standalone/ec2")
      host        = self.public_ip
    }
  }

}

# create a A record to assign it for a EC2 host
resource "aws_route53_record" "env-record" {
  zone_id         = var.zone_id
  name            = "my_EC2"
  type            = "A"
  ttl             = "300"
  records         = [aws_instance.my_EC2.public_ip]
  allow_overwrite = true
}



resource "aws_security_group" "web_sg" {
  name        = "webserver sg"
  description = "some sg"
  vpc_id      = aws_vpc.web_vpc.id

  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_vpc" "web_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.web_vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.web_vpc.id
}

resource "aws_route_table" "second_rt" {
  vpc_id = aws_vpc.web_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.second_rt.id
}
