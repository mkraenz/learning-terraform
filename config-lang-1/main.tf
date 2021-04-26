provider "aws" {
  region = "us-west-2"
}

provider "random" {}

resource "random_pet" "name" {
}

resource "aws_instance" "web" {
  ami                    = "ami-a0cfeed8"
  instance_type          = "t2.micro"
  user_data              = file("init-script.sh")
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = random_pet.name.id
  }
}

resource "aws_security_group" "web_sg" {
  name = "${random_pet.name.id}-sg"
  ingress = [{
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Incoming HTTP web traffic"
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  egress = [{
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    protocol         = "-1" # i.e. all. Forces from/to_port 0
    description      = "Allow all outgoing web traffic"
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]
}

output "domain-name" {
  value = aws_instance.web.public_dns
}

output "application-url" {
  value = "${aws_instance.web.public_dns}/index.php"
}
