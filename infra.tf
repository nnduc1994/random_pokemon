provider "aws" {
  region = "us-east-1"
}
#1 create vpc
resource "aws_vpc" "pokemon-dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "pokemon-dev"
  }
}

#2 create internet gateway
resource "aws_internet_gateway" "pokemon-gw" {
  vpc_id = aws_vpc.pokemon-dev-vpc.id
  tags = {
    Name = "pokemon-dev-gw"
  }
}

#3 create route table
resource "aws_route_table" "pokemon-dev-route-table" {
  vpc_id = aws_vpc.pokemon-dev-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pokemon-gw.id
  }
  tags = {
    Name = "pokemon-dev-gw"
  }
}

#4 create subnet
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.pokemon-dev-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "prod-subnet"
  }
}

#5 Associate subnet with Route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.pokemon-dev-route-table.id
}

#6 create security group
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow webtraffic"
  vpc_id = aws_vpc.pokemon-dev-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
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

  tags = {
    Name = "allow_web"
  }
}

#7 create network interface
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

#assign elastic ip address
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.pokemon-gw, aws_network_interface.web-server-nic]
}

#create ubuntu server
resource "aws_instance" "web-server-instance" {
  ami = "ami-0a0ddd875a1ea2c7f"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "terraform-ec2"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo echo "install docker completed"
              sudo git clone https://github.com/nnduc1994/random_pokemon.git app
              cd app
              docker image build -t duc/pokemon-api:latest --rm .
              sudo echo "docker image built successful"
              docker container run -d --name pokemon-api -p 80:8080 duc/pokemon-api:latest
              EOF
  tags = {
    Name = "pokemon-web-server"
  }
}

