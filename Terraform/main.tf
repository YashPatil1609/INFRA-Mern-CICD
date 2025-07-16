provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_range
    tags = {
        Name = "Demo-VPC"
    }
}

resource "aws_subnet" "myapp-subnet-1" {
    vpc_id     = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_range
    availability_zone = var.availability_zone
    tags = {
        Name = "Demo-Subnet-1"
    }
}

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id
    tags = {
        Name = "Demo-IGW"
    }
}

resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name = "Demo-Route-Table"
    }
}

resource "aws_route_table_association" "myapp-route-table-association" {
    subnet_id      = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_security_group" "myapp-sg" {
    vpc_id = aws_vpc.myapp-vpc.id
    name   = "Demo-SG"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 5173
        to_port     = 5173
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
        Name = "Demo-SG"
    }
}

data "aws_ami" "myapp-ami" {
    most_recent = true
    owners      = ["amazon"]
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "myapp-instance" {
    ami           = data.aws_ami.myapp-ami.id
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.availability_zone
    associate_public_ip_address = true
        user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y && sudo yum install -y docker
    sudo systemctl start docker
    sudo usermod -aG docker ec2-user
    
    # Docker-Compose Installation
    sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    EOF
       
                                            

    key_name = "demo_keypair"
    tags = {
        Name = "Demo-Instance"
    }
}

output "public-ip"{
    value = aws_instance.myapp-instance.public_ip
}
