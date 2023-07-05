provider "aws" {
  region     = "us-west-2"
  access_key = 
  secret_key = 
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.0.20230517.1-kernel-6.1-x86_64"]
  }
}
resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "first_keypair"
  
  
  provisioner "remote-exec" {
    connection {
    type ="ssh"
    user = "ec2-user"
    private_key =file("../section_5/first_keypair.pem")
    host= self.public_ip

    }
    #on_failure=continue
    inline = [
        "sudo yum install -y httpd",
        "sudo systemctl start httpd"
    ]
  }

}

output "ami_id" {
  value=aws_instance.example.ami
}
