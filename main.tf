
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}
resource "aws_subnet" "public_sub" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidr_block
  availability_zone = var.public_subnet_AZ

  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "private_sub" {
  count      = length(var.private_subnet_cidr_block)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block =var.private_subnet_cidr_block[count.index]
  availability_zone =var.private_subnet_AZ[count.index]
  tags = {
    Name = var.private_subnet_name
  }
}
resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = var.IG_name
  }
}
resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }
  tags = {
    Name = "rt_pub"
  }
}
resource "aws_route_table_association" "sub1" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.rt_pub.id
}
resource "aws_eip" "my_eip"{
  vpc = true
  tags = {
    Name = var.eip_name
  }
} 

resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_sub.id

  tags = {
    Name = var.NAT_GATEWAY
  }
}
resource "aws_route_table" "rt_pri" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat.id
  }
    tags = {
    Name = "rt_pri"
  }
}
resource "aws_route_table_association" "pri_sub" {
  count          = length(var.private_subnet_cidr_block)
  subnet_id      = aws_subnet.private_sub.*.id[count.index]
  route_table_id = aws_route_table.rt_pri.id
}
resource "aws_instance" "Pub-instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.Pub_Security_Group.id]
  subnet_id       = aws_subnet.public_sub.id
  associate_public_ip_address = true
  key_name        = var.key_pair
  user_data       = "${file("apache.sh")}"
  tags = {
  Name = var.public_instance_name
  }
}
# Create the Security Group
resource "aws_security_group" "Pub_Security_Group" {
  vpc_id       = aws_vpc.my_vpc.id
  name         = "Pub_Security_Group"
  description  = "My pub_ec2 Security Group"
  
  # allow ingress of port 22
 ingress{ 
    description ="SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow egress of all ports
 egress{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }  
  ingress {
   description       ="http"
   from_port         = 80
   to_port           = 80
   protocol          = "tcp"
   cidr_blocks       = ["0.0.0.0/0"]
  }
  tags = {
   Name = var.SG1
  }
}
resource "aws_db_subnet_group" "db_sg" {
  name       = "main"
  #count          = length(var.private_subnet_cidr_block)
  subnet_ids      = "${aws_subnet.private_sub.*.id}"
  #subnet_ids = element(aws_subnet.private_sub[count.index])
  
  tags = {
    Name = "DB subnet group"
  }
} 
resource "aws_db_instance" "DB-instance" {
  #identifier             = my_db
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.23"
  username               = "admin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_sg.name
  vpc_security_group_ids = [aws_security_group.Pri_Security_Group.id]
  #subnet_id              = aws_subnet.private_sub.id
  parameter_group_name   = "default.mysql8.0"
  publicly_accessible    = false
  skip_final_snapshot    = true
#  key_name        = "Terraform_key1"
  tags = {
  Name = var.db_instance_name
  }
}
resource "aws_security_group" "Pri_Security_Group" {
  vpc_id       = aws_vpc.my_vpc.id
  name         = "Pri_Security_Group"
  description  = "My pri_ec2 Security Group"
  
  # allow ingress of port 22
 ingress{ 
    description ="SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow egress of all ports
 egress{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }  
  ingress {
   description       ="RDS"
   from_port         = 3306
   to_port           = 3306
   protocol          = "tcp"
   cidr_blocks       = ["0.0.0.0/0"]
  }
  tags = {
   Name = var.SG2
  }
}

