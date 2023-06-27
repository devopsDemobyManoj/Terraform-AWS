resource "aws_instance" "ec2" {
  ami           = "ami-0e820afa569e84cc1" #us-east-2
  instance_type = "t2.micro"
  tags = {
      Name = "Terraform-Ansible"
  }
  key_name = "jenkinsDemo"
  security_groups = [sg-0d7515bee459b60fc]
}
