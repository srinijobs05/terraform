provider "aws" {
  profile ="terraform"
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami = "ami-0889a44b331db0194"
  instance_type = "t2.micro"
  tags = {
    Name="MyAppServer"
  }
}

resource "aws_s3_bucket" "test_bucket" {
  
}