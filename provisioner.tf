
provider "aws" {
  region     = "us-east-2" // YOU CAN USE ANY REGION. 
  access_key = "YOUR ACCESS KEY"
  secret_key = "YOUR SECRET KEY"
} 
data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
resource "aws_instance" "myec2" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t2.micro"
  key_name      = "terraform" // YOU HAVE TO CREATE A KEY IN AWS CONSOLE
  // AND PUT TO THE SAME DIRECTORY (FOLDER) WHERE YOU
  //RUNNING TERRAFORM FILE. 


  provisioner "remote-exec" {
    inline = [
  
      "sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
      "sudo yum -y install ansible"
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("./terraform.pem") // MY KEY NAME IS TERRAFORM.PEM YOU CAN USE YOUR KEY
    }

  }
}
