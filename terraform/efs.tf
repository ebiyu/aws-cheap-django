# Security Group for EFS
resource "aws_security_group" "efs_sg" {
  name        = "efs_sg"
  description = "Security group for EFS"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EFS File System
resource "aws_efs_file_system" "efs" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

# EFS Mount Target in private subnets
resource "aws_efs_mount_target" "efs_mount" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.efs_sg.id]
}

# EFS Access Point
resource "aws_efs_access_point" "efs_ap" {
  file_system_id = aws_efs_file_system.efs.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/lambda"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }
}

