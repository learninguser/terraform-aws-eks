resource "aws_spot_instance_request" "workstation" {
  ami                    = data.aws_ami.centos8.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_all_1.id]
  spot_type              = "one-time"
  user_data              = file("utils.sh")
  wait_for_fulfillment   = true

  tags = {
    Name = "workstation"
  }
}


resource "aws_ec2_tag" "tag" {
  resource_id = aws_spot_instance_request.workstation.spot_instance_id
  key         = "Name"
  value       = "workstation"
}
