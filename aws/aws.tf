# https://awstip.com/deploying-webapp-on-the-top-of-aws-using-terraform-8fd6401f612c

provider "aws" {
  region = "us-east-1"
  profile = "terraform"
}

resource "tls_private_key" "instance_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "key_pair_app" {
  key_name = "Webapp_key"
  public_key = tls_private_key.instance_key.public_key_openssh
}


resource "aws_security_group" "webapp_SG" {
  
  tags = {
    type="terraform-test-security-group"
  }
}

resource "aws_instance" "Webapp_inst" {
    ami = "ami-0889a44b331db0194"
    instance_type = "t2.micro"
    key_name = aws_key_pair.key_pair_app.key_name
    # security_groups = [ "webapp_SG" ]
    security_groups = [ aws_security_group.webapp_SG.name ]
    tags = {
        Name="Instance created by Terraform"
    }
  
}

resource "aws_ebs_volume" "ebs_vol1" {
  availability_zone = aws_instance.Webapp_inst.availability_zone
  size = 10
  tags = {
    Name = "webapp_vol"
  }
}

resource "aws_volume_attachment" "inst_ebs_attach" {
  device_name = "/dev/xvdh"
  instance_id = aws_instance.Webapp_inst.id
  volume_id = aws_ebs_volume.ebs_vol1.id
}